#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <cglm/cglm.h>

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	GLFWwindow *window;

	if (!glfwInit()) {
		return EXIT_FAILURE;
	}

	window = glfwCreateWindow(960, 540, "Test", NULL, NULL);
	if (!window) {
		glfwTerminate();
		return EXIT_FAILURE;
	}
	printf("Using GLFW %s\n", glfwGetVersionString());

	glfwMakeContextCurrent(window);

	GLenum error = glewInit();
	if (error != GLEW_OK) {
		glfwTerminate();
		fprintf(stderr, "%s", glewGetErrorString(error));
		return EXIT_FAILURE;
	}
	printf("Using GLEW %s\n", glewGetString(GLEW_VERSION));

	glClearColor(0.2f, 0.2f, 0.2f, 1.0f);

	while (!glfwWindowShouldClose(window)) {
		glClear(GL_COLOR_BUFFER_BIT);
		glfwSwapBuffers(window);
		glfwPollEvents();
	}

	glfwTerminate();

	return EXIT_SUCCESS;
}
