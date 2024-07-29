# The following is a cmake fragment taken from scripts/CMakeLists.txt and
# edited for Gentoo python multibuild compatibility.

if (PYTHON_BINDINGS)
	# Tags should be edited to reflect the active python implementation
	set(EPYTHON @@EPYTHON@@)
	set(PYTHON_INCUDE_DIR @@PYTHON_INCUDE_DIR@@)
	set(PYTHON_LIBS @@PYTHON_LIBS@@)
	set(PYTHON_SITEDIR @@PYTHON_SITEDIR@@)

	include_directories(${PYTHON_INCUDE_DIR})

	add_custom_command(
		OUTPUT ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON}/openbabel-python.cpp ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON}/openbabel.py
		COMMAND ${SWIG_EXECUTABLE} -python -c++ -small -O -templatereduce -naturalvar -I${CMAKE_SOURCE_DIR}/include -I${CMAKE_BINARY_DIR}/include -o ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON}/openbabel-python.cpp ${eigen_define} -outdir ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON} ${CMAKE_SOURCE_DIR}/scripts/openbabel-python.i
		MAIN_DEPENDENCY openbabel-python.i
		VERBATIM
	)

	configure_file(${CMAKE_SOURCE_DIR}/scripts/python/openbabel/__init__.py.in
		${CMAKE_BINARY_DIR}/scripts/${EPYTHON}/openbabel/__init__.py)

	add_library(bindings_python_${EPYTHON} MODULE ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON}/openbabel-python.cpp)
	target_link_libraries(bindings_python_${EPYTHON} ${PYTHON_LIBS} ${BABEL_LIBRARY})

	set_target_properties(bindings_python_${EPYTHON}
		PROPERTIES
		OUTPUT_NAME _openbabel
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/scripts/${EPYTHON}/openbabel
		PREFIX ""
		SUFFIX .so )

	add_dependencies(bindings_python_${EPYTHON} openbabel)

	install(TARGETS bindings_python_${EPYTHON}
		LIBRARY DESTINATION ${PYTHON_SITEDIR}/openbabel
		COMPONENT bindings_python)
	install(FILES ${CMAKE_BINARY_DIR}/scripts/${EPYTHON}/openbabel/__init__.py
		DESTINATION ${PYTHON_SITEDIR}/openbabel
		COMPONENT bindings_python)
	install(FILES ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON}/openbabel.py
		DESTINATION ${PYTHON_SITEDIR}/openbabel
		COMPONENT bindings_python)
	install(FILES ${CMAKE_SOURCE_DIR}/scripts/python/openbabel/pybel.py
		DESTINATION ${PYTHON_SITEDIR}/openbabel
		COMPONENT bindings_python)

	if (ENABLE_TESTS)
		# Make sure all module files are together in the same directory for testing
		add_custom_command(TARGET bindings_python_${EPYTHON} POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/scripts/${EPYTHON}/openbabel.py ${CMAKE_BINARY_DIR}/scripts/${EPYTHON}/openbabel/
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/scripts/python/openbabel/pybel.py ${CMAKE_BINARY_DIR}/scripts/${EPYTHON}/openbabel/)
		set(TEST_SOURCE_DIR ${CMAKE_SOURCE_DIR}/test)
		# define TESTDATADIR for tests that need input files
		add_definitions(-DTESTDATADIR="${TEST_SOURCE_DIR}/files/")
		# define FORMATDIR for location of format plugin binaries
		set(FORMATDIR "${CMAKE_BINARY_DIR}/lib${LIB_SUFFIX}/")
		add_definitions(-DFORMATDIR="${FORMATDIR}/")
		include_directories(${TEST_SOURCE_DIR})

		# The macro is modified from cmake/modules/UsePythonTest.cmake
		MACRO(ADD_PYTHON_TEST TESTNAME FILENAME)
			GET_SOURCE_FILE_PROPERTY(loc ${FILENAME} LOCATION)
			STRING(REGEX REPLACE ";" " " wo_semicolumn "${ARGN}")
			FILE(WRITE ${CMAKE_BINARY_DIR}/test/${TESTNAME}.cmake
"
	MESSAGE(\"${PYTHONPATH}\")
	EXECUTE_PROCESS(
		COMMAND ${EPYTHON} ${loc} ${wo_semicolumn}
		RESULT_VARIABLE import_res
		OUTPUT_VARIABLE import_output
		ERROR_VARIABLE  import_output
	)

	# Pass the output back to ctest
	IF(import_output)
		MESSAGE(\${import_output})
	ENDIF(import_output)
	IF(import_res)
		MESSAGE(SEND_ERROR \${import_res})
	ENDIF(import_res)
"
			)
			ADD_TEST(${TESTNAME} ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/test/${TESTNAME}.cmake)
		ENDMACRO(ADD_PYTHON_TEST)

		set(pybindtests
			bindings
			_pybel
			example 
			obconv_writers
			cdjsonformat
			pcjsonformat
			roundtrip
			)
		foreach(pybindtest ${pybindtests})
			ADD_PYTHON_TEST(pybindtest_${pybindtest}_${EPYTHON} ${TEST_SOURCE_DIR}/test${pybindtest}.py)
			set_tests_properties(pybindtest_${pybindtest}_${EPYTHON} PROPERTIES
				ENVIRONMENT "PYTHONPATH=${CMAKE_BINARY_DIR}/scripts/${EPYTHON}:${CMAKE_BINARY_DIR}/lib${LIB_SUFFIX};LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/scripts/${EPYTHON}:${CMAKE_BINARY_DIR}/lib${LIB_SUFFIX}:\$ENV{LD_LIBRARY_PATH};BABEL_LIBDIR=${CMAKE_BINARY_DIR}/lib${LIB_SUFFIX}/;BABEL_DATADIR=${CMAKE_SOURCE_DIR}/data"
				FAIL_REGULAR_EXPRESSION "ERROR;FAIL;Test failed"
			)
		endforeach(pybindtest ${pybindtests})
	endif (ENABLE_TESTS)
endif(PYTHON_BINDINGS)
