import numpy as np
from time import time
def objective_function(x):
    # Critérios de penalização
    r = 12
    s = 15
    
    # Cálculo do fitness
    d = len(x)
    fx = 10 * d + np.sum(x**2 - 10 * np.cos(2 * np.pi * x))  # Fitness do indivíduo (RASTRIGIN)

    gx = np.sum(r * np.maximum(0, np.sin(2 * np.pi * x) + 0.5))   # gi(x) desigualdade
    hx = np.sum(s * np.abs(np.cos(2 * np.pi * x) + 0.5))        # hi(x0) igualdade

    px = fx + gx + hx                                # Fitness com penalizações aplicadas
    
    return px



def pso(num_particles, num_dimensions, num_iterations, w, c1, c2, lim_inf, lim_sup):
    start_time = time()

    np.random.seed(79)#80#81

    particles_position = np.random.uniform(low=lim_inf, high=lim_sup, size=(num_particles, num_dimensions))
    particles_velocity = np.random.uniform(size=(num_particles, num_dimensions))

    personal_best_positions = particles_position.copy()
    personal_best_values = [objective_function(p) for p in particles_position]

    global_best_index = np.argmin(personal_best_values)
    global_best_position = particles_position[global_best_index].copy()
    global_best_value = objective_function(global_best_position)

    for it in range(num_iterations):
        progress = (it * 100) / num_iterations
        print(f'\r Iteração {it + 1}. Concluído {progress:.2f}% ', end='', flush=True)

        for i in range(num_particles):

            inertia_vector = w*particles_velocity[i]
            local_vector = c1*(personal_best_positions[i] - particles_position[i])
            global_vector = c2*(global_best_position - particles_position[i])

            particles_velocity[i] = inertia_vector + local_vector + global_vector

            particles_position[i] += particles_velocity[i]

            current_value = objective_function(particles_position[i])

            if current_value < personal_best_values[i]:
                personal_best_values[i] = current_value
                personal_best_positions[i] = particles_position[i].copy()

                if current_value < global_best_value:
                    global_best_value = current_value
                    global_best_position = particles_position[i].copy()

    end_time = time()
    return global_best_position, global_best_value, (end_time-start_time)


num_particles = 130
num_dimensions = 5 #4
num_iterations = 100
w  = 0.5#0.673 #0.672 # Coeficiente de inércia
c1 = 1.2#1.27 #1.4  # Coeficiente cognitivo
c2 = 1.6 #1.6  # Coeficiente social

# Executar o PSO
best_position, best_value, time = pso(num_particles, num_dimensions, num_iterations, w, c1, c2, -5.12, 5.12)
print()
print(best_position)
print(best_value)
print(time)