# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit pax-utils python-any-r1 toolchain-funcs

MY_P=pypy3.7-v${PV/_/}

DESCRIPTION="A fast, compliant alternative implementation of the Python (3.7) language"
HOMEPAGE="https://pypy.org/"
SRC_URI="https://downloads.python.org/pypy/${MY_P}-src.tar.bz2"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
# pypy3 -c 'import sysconfig; print(sysconfig.get_config_var("SOABI"))'
SLOT="0/pypy37-pp73"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 gdbm +jit libressl ncurses sqlite test tk"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-python/pypy3-exe:${PV}-py37[bzip2?,ncurses?]
		dev-python/pypy3-exe-bin:${PV}-py37
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	gdbm? ( sys-libs/gdbm:0= )
	sqlite? ( dev-db/sqlite:3= )
	tk? (
		dev-lang/tk:0=
		dev-tcltk/tix:0=
	)
	!<dev-python/pypy3-bin-7.3.0:0"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
		!!dev-python/pytest-forked
	)"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}/7.3.1-gentoo-path.patch"
	eapply "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"
	eapply "${FILESDIR}/7.3.2-py37-distutils-cxx.patch"

	sed -e "s^@EPREFIX@^${EPREFIX}^" \
		-i lib-python/3/distutils/command/install.py || die

	# apply CPython stdlib patches
	pushd lib-python/3 > /dev/null || die
	eapply "${FILESDIR}"/python-3.5-distutils-OO-build.patch
	popd > /dev/null || die

	# see http://buildbot.pypy.org/summary?branch=py3.7&builder=pypy-c-jit-linux-x86-64
	sed -i -e 's:test_snippets(:_&:' \
		lib-python/3/test/test_ast.py || die
	sed -i -e 's:testConstructorErrorMessages(:_&:' \
		lib-python/3/test/test_class.py || die
	sed -i -e 's:test_pythonmalloc(:_&:' \
		-e 's:test_sys_flags_set(:_&:' \
		-e 's:test_unbuffered_output(:_&:' \
		-e 's:test_xdev(:_&:' \
		-e 's:test_ignore_PYTHONHASHSEED(:_&:' \
		lib-python/3/test/test_cmd_line.py || die
	sed -i -e 's:test_consistent_sys_path_for_module_execution(:_&:' \
		-e 's:test_issue8202(:_&:' \
		-e 's:test_issue8202_dash_m_file_ignored(:_&:' \
		-e 's:test_module_in_package(:_&:' \
		-e 's:test_module_in_package_in_zipfile(:_&:' \
		-e 's:test_module_in_subpackage_in_zipfile(:_&:' \
		-e 's:test_nonexisting_script(:_&:' \
		-e 's:test_package(:_&:' \
		-e 's:test_package_compiled(:_&:' \
		-e 's:test_script_compiled(:_&:' \
		lib-python/3/test/test_cmd_line_script.py || die
	sed -i -e 's:test_incremental_errors(:_&:' \
		lib-python/3/test/test_codecs.py || die
	sed -i -e 's:test_ressources_gced_in_workers(:_&:' \
		-e 's:test_submit_after_interpreter_shutdown(:_&:' \
		lib-python/3/test/test_concurrent_futures.py || die
	sed -i -e 's:test_for_3(:_&:' \
		-e 's:test_func_4(:_&:' \
		lib-python/3/test/test_coroutines.py || die
	sed -i -e 's:test_strftime(:_&:' \
		-e 's:test_more_strftime(:_&:' \
		lib-python/3/test/datetimetester.py || die
	sed -i -e 's:test_info(:_&:' \
		-e 's:test_code_info(:_&:' \
		-e 's:test_show_code(:_&:' \
		-e 's:test_disassemble_recursive(:_&:' \
		-e 's:test_disassemble_str(:_&:' \
		-e 's:test_jumpy(:_&:' \
		lib-python/3/test/test_dis.py || die
	sed -i -e 's:test_generator_doesnt_retain_old_exc2(:_&:' \
		-e 's:test_attributes(:_&:' \
		lib-python/3/test/test_exceptions.py || die
	sed -i -e 's:test_frozen(:_&:' \
		lib-python/3/test/test_frozen.py || die
	sed -i -e 's:test_ssl_raises(:_&:' \
		-e 's:test_ssl_verified(:_&:' \
		lib-python/3/test/test_imaplib.py || die
	sed -i -e 's:test_script_compiled(:_&:' \
		lib-python/3/test/test_multiprocessing_main_handling.py || die
	sed -i -e 's:test_execve_invalid_env(:_&:' \
		lib-python/3/test/test_os.py || die
	sed -i -e 's:test_get_and_set_scheduler_and_param(:_&:' \
		lib-python/3/test/test_posix.py || die
	sed -i -e 's:test_copying(:_&:' \
		-e 's:test_re_split(:_&:' \
		-e 's:test_zerowidth(:_&:' \
		-e 's:test_locale_caching(:_&:' \
		-e 's:test_locale_compiled(:_&:' \
		-e 's:test_match_repr(:_&:' \
		-e 's:test_qualified_re_split(:_&:' \
		-e 's:test_scoped_flags(:_&:' \
		lib-python/3/test/test_re.py || die
	sed -i -e 's:test_auto_history_disabled(:_&:' \
		-e 's:test_auto_history_enabled(:_&:' \
		-e 's:test_history_size(:_&:' \
		lib-python/3/test/test_readline.py || die
	sed -i -e 's:test_multiprocess(:_&:' \
		lib-python/3/test/test_regrtest.py || die
	sed -i -e 's:test_warn_on_full_buffer(:_&:' \
		lib-python/3/test/test_signal.py || die
	sed -i -e 's:test_get_path(:_&:' \
		lib-python/3/test/test_site.py || die
	sed -i -e 's:test_check_hostname(:_&:' \
		-e 's:test_npn_protocols(:_&:' \
		-e 's:test_sni_callback(:_&:' \
		-e 's:test_sni_callback_raising(:_&:' \
		lib-python/3/test/test_ssl.py || die
	sed -i -e 's:test_invalid_placeholders(:_&:' \
		lib-python/3/test/test_string.py || die
	sed -i -e 's:test_eval_bytes_invalid_escape(:_&:' \
		-e 's:test_eval_str_invalid_escape(:_&:' \
		lib-python/3/test/test_string_literals.py || die
	sed -i -e 's:test_boundary_error_message_with_large_offset(:_&:' \
		lib-python/3/test/test_struct.py || die
	sed -i -e 's:test_restore_signals(:_&:' \
		lib-python/3/test/test_subprocess.py || die
	sed -i -e 's:test_jump_out_of_async_for_block_backwards(:_&:' \
		-e 's:test_jump_out_of_async_for_block_forwards(:_&:' \
		-e 's:test_jump_over_async_for_block_before_else(:_&:' \
		-e 's:test_no_jump_backwards_into_async_for_block(:_&:' \
		-e 's:test_no_jump_forwards_into_async_for_block(:_&:' \
		-e 's:test_no_jump_into_async_for_block_before_else(:_&:' \
		-e 's:test_no_jump_from_yield(:_&:' \
		lib-python/3/test/test_sys_settrace.py || die
	sed -i -e 's:test_install_schemes(:_&:' \
		lib-python/3/test/test_sysconfig_pypy.py || die
	sed -i -e 's:test_circular_imports(:_&:' \
		lib-python/3/test/test_threaded_import.py || die
	sed -i -e 's:test_main_milliseconds(:_&:' \
		-e 's:test_main_verbose(:_&:' \
		-e 's:test_main_very_verbose(:_&:' \
		-e 's:test_main_with_time_unit(:_&:' \
		lib-python/3/test/test_timeit.py || die
	sed -i -e 's:test_cannot_subclass(:_&:' \
		lib-python/3/test/test_typing.py || die
	sed -i -e 's:test_warnings(:_&:' \
		lib-python/3/unittest/test/test_runner.py || die
	sed -i -e 's:test_cmd_line(:_&:' \
		-e 's:test_env_var(:_&:' \
		-e 's:test_locale_getpreferredencoding(:_&:' \
		-e 's:test_posix_locale(:_&:' \
		-e 's:test_stdio(:_&:' \
		-e 's:test_xoption(:_&:' \
		lib-python/3/test/test_utf8_mode.py || die
	sed -i -e 's:test_asyncgen_finalization_by_gc(:_&:' \
		-e 's:test_asyncgen_finalization_by_gc_in_other_thread(:_&:' \
		-e 's:test_create_connection_ipv6_scope(:_&:' \
		lib-python/3/test/test_asyncio/test_base_events.py || die
	sed -i -e 's:test_buffered_proto_create_connection(:_&:' \
		lib-python/3/test/test_asyncio/test_buffered_proto.py || die
	sed -i -e 's:test_create_connection_memory_leak(:_&:' \
		-e 's:test_handshake_timeout(:_&:' \
		-e 's:test_start_tls_client_reg_proto_1(:_&:' \
		lib-python/3/test/test_asyncio/test_sslproto.py || die
	sed -i -e 's:test_bare_create_task(:_&:' \
		-e 's:test_current_task(:_&:' \
		lib-python/3/test/test_asyncio/test_tasks.py || die
	sed -i -e 's:test_asyncio_task_decimal_context(:_&:' \
		lib-python/3/test/test_asyncio/test_context.py || die
	sed -i -e 's:test_create_server_ssl_match_failed(:_&:' \
		lib-python/3/test/test_asyncio/test_events.py || die
	sed -i -e 's:test_binding(:_&:' \
		-e 's:test_from_import_AttributeError(:_&:' \
		-e 's:test_from_import_missing_attr_has_name_and_path(:_&:' \
		-e 's:test_from_import_missing_attr_path_is_canonical(:_&:' \
		lib-python/3/test/test_import/__init__.py || die
	sed -i -e 's:test_unrelated_contents(:_&:' \
		-e 's:test_contents(:_&:' \
		-e 's:test_submodule_contents(:_&:' \
		-e 's:test_submodule_contents_by_name(:_&:' \
		-e 's:test_is_resource_good_path(:_&:' \
		-e 's:test_is_submodule_resource(:_&:' \
		-e 's:test_read_submodule_resource_by_name(:_&:' \
		lib-python/3/test/test_importlib/test_resource.py || die
	sed -i -e 's:test_non_string_keys_dict(:_&:' \
		lib-python/3/test/test_json/test_fail.py || die
	sed -i -e 's:test_module(:_&:' \
		lib-python/3/test/test_warnings/__init__.py || die

	# flaky
	sed -i -e 's:test_2_join_in_forked_process(:_&:' \
		lib-python/3/test/test_threading.py || die

	# TODO
	sed -i -e 's:test_external_target_locale_configuration(:_&:' \
		lib-python/3/test/test_c_locale_coercion.py || die
	sed -i -e 's:test_locale(:_&:' \
		lib-python/3/test/test_format.py || die
	sed -i -e 's:test_decompressor_bug_28275(:_&:' \
		lib-python/3/test/test_lzma.py || die
	sed -i -e 's:test_wrapped_exception:_&:' \
		lib-python/3/test/_test_multiprocessing.py || die
	sed -i -e 's:test_https_sni(:_&:' \
		lib-python/3/test/test_urllib2_localnet.py || die

	# the first one's broken by sandbox, the second by our env
	sed -i -e 's:test_executable(:_&:' \
		-e 's:test_executable_without_cwd(:_&:' \
		lib-python/3/test/test_subprocess.py || die

	eapply_user
}

src_configure() {
	tc-export CC
}

src_compile() {
	# copy over to make sys.prefix happy
	cp -p "${BROOT}"/usr/lib/pypy3.7/pypy3-c-${PV} pypy3-c || die
	cp -p "${BROOT}"/usr/lib/pypy3.7/include/${PV}/* include/ || die
	# (not installed by pypy)
	rm pypy/module/cpyext/include/_numpypy/numpy/README || die
	mv pypy/module/cpyext/include/* include/ || die
	mv pypy/module/cpyext/parse/*.h include/ || die
	pax-mark m pypy3-c

	einfo "Generating caches and CFFI modules ..."

	# Generate Grammar and PatternGrammar pickles.
	./pypy3-c -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi modules
	# Please keep in sync with pypy/tool/build_cffi_imports.py!
#cffi_build_scripts = {
#    "_blake2": "_blake2/_blake2_build.py",
#    "_ssl": "_ssl_build.py",
#    "sqlite3": "_sqlite3_build.py",
#    "audioop": "_audioop_build.py",
#    "tk": "_tkinter/tklib_build.py",
#    "curses": "_curses_build.py" if sys.platform != "win32" else None,
#    "syslog": "_syslog_build.py" if sys.platform != "win32" else None,
#    "gdbm": "_gdbm_build.py"  if sys.platform != "win32" else None,
#    "pwdgrp": "_pwdgrp_build.py" if sys.platform != "win32" else None,
#    "resource": "_resource_build.py" if sys.platform != "win32" else None,
#    "lzma": "_lzma_build.py",
#    "_decimal": "_decimal_build.py",
#    "_sha3": "_sha3/_sha3_build.py",
	cffi_targets=( blake2/_blake2 sha3/_sha3 ssl
		audioop syslog pwdgrp resource lzma decimal )
	use gdbm && cffi_targets+=( gdbm )
	use ncurses && cffi_targets+=( curses )
	use sqlite && cffi_targets+=( sqlite3 )
	use tk && cffi_targets+=( tkinter/tklib )

	local t
	# all modules except tkinter output to .
	# tkinter outputs to the correct dir ...
	cd lib_pypy || die
	for t in "${cffi_targets[@]}"; do
		# tkinter doesn't work via -m
		../pypy3-c "_${t}_build.py" || die "Failed to build CFFI bindings for ${t}"
	done

	# Cleanup temporary objects
	find -name "_cffi_*.[co]" -delete || die
	find -type d -empty -delete || die
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE=
	local -x COLUMNS=80

	local ignore=(
		# failing doctests
		lib-python/3/test/test_extcall.py
		lib-python/3/test/test_unpack_ex.py

		# segfault
		lib-python/3/test/test_capi.py
	)

	# Test runner requires Python 2 too. However, it spawns PyPy3
	# internally so that we end up testing the correct interpreter.
	# (--deselect for failing doctests)
	"${EPYTHON}" ./pypy/test_all.py --pypy=./pypy3-c -vv lib-python \
		${ignore[@]/#/--ignore } || die
}

src_install() {
	local dest=/usr/lib/pypy3.7
	einfo "Installing PyPy ..."
	dosym pypy3-c-${PV} "${dest}/pypy3-c"
	insinto "${dest}"
	# preserve mtimes to avoid obsoleting caches
	insopts -p
	doins -r include lib_pypy lib-python

	# replace copied headers with symlinks
	for x in "${BROOT}"/usr/lib/pypy3.7/include/${PV}/*; do
		dosym "${PV}/${x##*/}" "${dest}/include/${x##*/}"
	done

	dosym ../lib/pypy3.7/pypy3-c /usr/bin/pypy3
	dodoc README.rst

	if ! use gdbm; then
		rm -r "${ED}${dest}"/lib_pypy/_gdbm* || die
	fi
	if ! use sqlite; then
		rm -r "${ED}${dest}"/lib-python/*3/sqlite3 \
			"${ED}${dest}"/lib_pypy/_sqlite3* \
			"${ED}${dest}"/lib-python/*3/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED}${dest}"/lib-python/*3/{idlelib,tkinter} \
			"${ED}${dest}"/lib_pypy/_tkinter \
			"${ED}${dest}"/lib-python/*3/test/test_{tcl,tk,ttk*}.py || die
	fi

	local -x EPYTHON=pypy3
	local -x PYTHON=${ED}${dest}/pypy3-c

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_moduleinto /usr/lib/pypy3.7/site-packages
	python_domodule epython.py

	einfo "Byte-compiling Python standard library..."
	python_optimize "${ED}${dest}"
}
