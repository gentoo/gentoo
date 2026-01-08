# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Set of facilities to extend Python with C++"
HOMEPAGE="https://cxx.sourceforge.net"
SRC_URI="https://dev.gentoo.org/~gienah/snapshots/${P}.zip"

S="${WORKDIR}"/cxx-code-r465-trunk/CXX

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-macos"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' 3.12)
	app-arch/unzip
"

python_prepare_all() {
	rm -R Src/Python2/ || die

	# Without this, pysvn fails.
	# Src/Python3/cxxextensions.c: No such file or directory
	sed -e "/^#include/s:Src/::" -i Src/*.{c,cxx} || die "sed failed"

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
	if use test; then
		pushd Src || die
		local S_SRCS="cxx_exceptions.cxx cxxextensions.c cxx_extensions.cxx cxxsupport.cxx IndirectPythonInterface.cxx"
		local S_OBJS=""
		for i in ${S_SRCS}; do
			local S_O="${BUILD_DIR}/${i%%.c*}.o"
			local c_cmd=(
				$(tc-getCXX) \
					${CPPFLAGS} ${CFLAGS} ${ASFLAGS} \
					-I"${S}" -I"${EPREFIX}/usr/include/${EPYTHON}" \
					-fPIC -c ${i} -o "${S_O}"
			)
			printf '%s\n' "${c_cmd[*]}"
			"${c_cmd[@]}" || die "compile test ${i} failed"
			S_OBJS+="${S_O} "
		done
		popd || die
		pushd Demo/Python3 || die
		cp -p test_example.py "${BUILD_DIR}" || die
		local D_SRCS="example.cxx range.cxx rangetest.cxx"
		local D_OBJS=""
		for i in ${D_SRCS}; do
			local D_O="${BUILD_DIR}/${i%%.c*}.o"
			local c_cmd=(
				$(tc-getCXX) \
					${CPPFLAGS} ${CFLAGS} ${ASFLAGS} \
					-I"${S}" -I"${S}"/Demo/Python3 -I"${EPREFIX}/usr/include/${EPYTHON}" \
					-fPIC -c ${i} -o "${D_O}"
			)
			printf '%s\n' "${c_cmd[*]}"
			"${c_cmd[@]}" || die "compile test ${i} failed"
			S_OBJS+="${D_O} "
		done
		local l_example_cmd=(
			$(tc-getCXX) \
				${CPPFLAGS} ${CFLAGS} ${ASFLAGS} \
				-I$"{S}" -I"${S}"/Demo/Python3 -I$"{EPREFIX}/usr/include/${EPYTHON}" \
				-shared -fPIC -o "${BUILD_DIR}"/example.so ${S_OBJS} ${D_OBJS} -l${EPYTHON} -ldl
		)
		printf '%s\n' "${l_example_cmd[*]}"
		"${l_example_cmd[@]}" || die "link test example.so failed"
		popd || die
	fi
}

python_test() {
	pushd "${BUILD_DIR}" || die
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}"
	local cmd=(
		"${EPYTHON}" test_example.py
	)
	printf '%s\n' "${cmd[*]}"
	"${cmd[@]}" || die "test_example failed"
	popd || die
}

python_install() {
	distutils-r1_python_install

	# Move misplaced files into place
	dodir "/usr/share/${EPYTHON}"
	mv "${D}/usr/CXX" "${D}/usr/share/${EPYTHON}/CXX" || die
	mv "${D}/usr/include/${EPYTHON}"/{cxx,CXX} || die
}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/. )
	if use examples ; then
		docinto examples
		dodoc -r Demo/Python3/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
