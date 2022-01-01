# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
VIRTUALX_REQUIRED="manual"

inherit flag-o-matic java-pkg-opt-2 java-ant-2 toolchain-funcs virtualx wxwidgets

DESCRIPTION="A WAM based Prolog system"
HOMEPAGE="http://ctp.di.fct.unl.pt/~amd/cxprolog"
SRC_URI="http://ctp.di.fct.unl.pt/~amd/cxprolog/cxunix/${P}.src.tgz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples java +readline test wxwidgets"
RESTRICT="!test? ( test )"

RDEPEND="readline? ( sys-libs/readline:= )
	java? ( >=virtual/jdk-1.8:= )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"

DEPEND="${RDEPEND}
	test? (
		java? ( ${VIRTUALX_DEPEND} )
		wxwidgets? ( ${VIRTUALX_DEPEND} )
	)"

S="${WORKDIR}"/${P}

src_prepare() {
	eapply "${FILESDIR}"/${P}-portage.patch
	eapply "${FILESDIR}"/${P}-test-io.patch
	eapply_user

	sed -i -e "s|lib/cxprolog|$(get_libdir)/cxprolog|" "${S}"/src/FileSys.c || die
	cp "${FILESDIR}"/build.xml "${S}"/build.xml || die
	cp "${FILESDIR}"/cx_dev_boot.pl "${S}"/cx_dev_boot.pl || die
	rm -f "${S}"/pl/test_file_io_1.txt

	use wxwidgets && setup-wxwidgets
}

src_compile() {
	local CX_EXT_DEFINES
	local CX_EXT_CFLAGS
	local CX_EXT_LDFLAGS
	local CX_EXT_LIBS

	if use readline; then
		CX_EXT_DEFINES="$CX_EXT_DEFINES -DUSE_READLINE"
		CX_EXT_LIBS="$CX_EXT_LIBS -lreadline"
	fi

	if use java; then
		local java_arch
		use x86 && java_arch=i386
		use amd64 && java_arch=amd64
		CX_JVM="${JAVA_HOME}/jre/lib/${java_arch}/server"
		CX_EXT_DEFINES="$CX_EXT_DEFINES -DUSE_JAVA"
		CX_EXT_CFLAGS="$CX_EXT_CFLAGS $(java-pkg_get-jni-cflags)"
		CX_EXT_LDFLAGS="$CX_EXT_LDFLAGS -Wl,-rpath,${CX_JVM}"
		CX_EXT_LIBS="$CX_EXT_LIBS -L${CX_JVM} -ljvm"
	fi

	if use wxwidgets; then
		CX_EXT_DEFINES="$CX_EXT_DEFINES -DUSE_WXWIDGETS"
		CX_EXT_CFLAGS="$CX_EXT_CFLAGS $(${WX_CONFIG} --cflags)"
		CX_EXT_LIBS="$CX_EXT_LIBS $(${WX_CONFIG} --libs)"
	fi

	emake lib \
		PREFIX=/usr \
		TMP_DIR="${S}/tmp" \
		CC=$(tc-getCC) \
		CPP=$(tc-getCXX) \
		LD=$(tc-getLD) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		EXT_DEFINES="${CX_EXT_DEFINES}" \
		EXT_CFLAGS="-Wall ${CX_EXT_CFLAGS}" \
		EXT_LDFLAGS="${CX_EXT_LDFLAGS}" \
		EXT_LIBS="${CX_EXT_LIBS}"

	if use java; then
		JAVA_SRC_DIR="${S}/lib/cxprolog/java"
		eant jar
	fi
}

cxprolog_src_test() {
	cd "${S}"/pl

	LD_LIBRARY_PATH="${S}" \
		"${S}"/cxprolog_shared \
		--boot "${S}"/cx_dev_boot.pl \
		--script "${S}"/pl/test_all.pl \
		| tee "${S}"/cxprolog_test.log
}

src_test() {
	if use java || use wxwidgets; then
		virtx cxprolog_src_test
	else
		cxprolog_src_test
	fi

	grep -q "ALL THE TESTS PASSED" "${S}"/cxprolog_test.log \
		|| die "cxprolog unit tests failed"
}

src_install() {
	newbin cxprolog_shared cxprolog
	dolib.so libcxprolog.so

	insinto /usr/$(get_libdir)/cxprolog
	doins lib/cxprolog/lib.pl

	insinto /usr/share/${PN}/pl
	doins pl/*.{pl,txt}

	if use java; then
		insinto /usr/$(get_libdir)/cxprolog/java
		doins dist/prolog.jar
	fi

	dodoc ChangeLog.txt MANUAL.txt README.txt

	if use examples; then
		dodoc -r examples
	fi
}
