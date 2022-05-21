# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common flag-o-matic java-pkg-opt-2 multilib vcs-clean xdg-utils

PATCHSET_VER="0"
MY_P=${PN}-srcdist-${PV}

DESCRIPTION="Mercury is a modern general-purpose logic/functional programming language"
HOMEPAGE="https://www.mercurylang.org/index.html"
SRC_URI="https://dl.mercurylang.org/release/${MY_P}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/mercury/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc emacs examples java mono profile readline test threads trail"

DEPEND="net-libs/libnsl:0=
	readline? ( sys-libs/readline:= )
	java? ( >=virtual/jdk-1.8:* )
	mono? ( dev-lang/mono )
	doc? ( sys-apps/texinfo )"

RDEPEND="${DEPEND}
	emacs? ( >=app-editors/emacs-23.1:* )"

BDEPEND="test? ( sys-libs/timezone-data )"

S="${WORKDIR}"/${MY_P}

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi
	eapply_user

	AT_M4DIR=m4 eautoreconf

	xdg_environment_reset
}

src_configure() {
	strip-flags

	local myconf
	myconf="--libdir=/usr/$(get_libdir) \
		$(use_enable mono csharp-grade) \
		$(use_enable java java-grade) \
		$(use_enable debug debug-grades) \
		$(use_enable profile prof-grades) \
		$(use_enable threads par-grades) \
		$(use_enable trail trail-grades) \
		$(use_with readline)"

	econf ${myconf}
}

src_compile() {
	# Prepare mmake flags
	echo "EXTRA_CFLAGS = ${CFLAGS} -Wno-error"  >> Mmake.params
	echo "EXTRA_LDFLAGS = ${LDFLAGS}" >> Mmake.params
	echo "EXTRA_LD_LIBFLAGS = ${LDFLAGS}" >> Mmake.params
	echo "EXTRA_MLFLAGS = --no-strip" >> Mmake.params

	if use trail; then
		echo "CFLAGS-int = -O0" >> Mmake.params
		echo "CFLAGS-uint = -O0" >> Mmake.params
	fi

	echo "EXTRA_LD_LIBFLAGS += -Wl,-soname=libgc.so" >> boehm_gc/Mmake.boehm_gc.params
	echo "EXTRA_LD_LIBFLAGS += -Wl,-soname=libmer_rt.so" >> runtime/Mmake.runtime.params
	echo "EXTRA_LD_LIBFLAGS += -Wl,-soname=libmer_std.so" >> library/Mmake.library.params

	# Build Mercury using bootstrap grade
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		TEXI2DVI="" PDFTEX=""

	# We can now patch .m Mercury compiler files since we
	# have just built mercury_compiler.
	if [[ -d "${WORKDIR}"/${PV}-mmc ]] ; then
		eapply "${WORKDIR}"/${PV}-mmc
	fi

	# Rebuild Mercury compiler using the just built mercury_compiler
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		TEXI2DVI="" PDFTEX=""

	# The default Mercury grade may not be the same as the bootstrap
	# grade. Since src_test() is run before src_install() we compile
	# the default grade now
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		TEXI2DVI="" PDFTEX="" \
		default_grade
}

src_test() {
	TEST_GRADE=$(scripts/ml --print-grade)
	if [ -d "${S}"/install_grade_dir.${TEST_GRADE} ] ; then
		TWS="${S}"/install_grade_dir.${TEST_GRADE}
		cp runtime/mer_rt.init "${TWS}"/runtime/
		cp mdbcomp/mer_mdbcomp.init "${TWS}"/mdbcomp/
		cp browser/mer_browser.init "${TWS}"/browser/
	else
		TWS="${S}"
	fi

	cd "${S}"/tests || die
	sed -e "s:@WORKSPACE@:${TWS}:" \
		< WS_FLAGS.ws \
		> WS_FLAGS \
		|| die "sed WORKSPACE failed"
	sed -e "s:@WORKSPACE@:${TWS}:" \
		< .mgnuc_copts.ws \
		> .mgnuc_copts \
		|| die "sed WORKSPACE failed"
	find . -mindepth 1 -type d -exec cp .mgnuc_opts  {} \;
	find . -mindepth 1 -type d -exec cp .mgnuc_copts {} \;

	# Mercury tests must be run in C locale since Mercury output is
	# compared to hard-coded warnings/errors
	LC_ALL="C" \
	PATH="${TWS}"/scripts:"${TWS}"/util:"${S}"/slice:"${PATH}" \
	TERM="" \
	WORKSPACE="${TWS}" \
	WORKSPACE_FLAGS=yes \
	MERCURY_COMPILER="${TWS}"/compiler/mercury_compile \
	MMAKE_DIR="${TWS}"/scripts \
	MERCURY_SUPPRESS_STACK_TRACE=yes \
	GRADE=${TEST_GRADE} \
		mmake || die "mmake test failed"
}

src_install() {
	emake \
		PARALLEL="'${MAKEOPTS}'" \
		MERCURY_COMPILER="${S}"/compiler/mercury_compile \
		TEXI2DVI="" PDFTEX="" \
		DESTDIR="${D}" \
		INSTALL_ELISP_DIR="${D}/${SITELISP}"/${PN} \
		install

	if use java; then
		keepdir /usr/$(get_libdir)/mercury/modules/java
	fi

	if use mono; then
		keepdir /usr/$(get_libdir)/mercury/modules/csharp
	fi

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi

	dodoc \
		BUGS HISTORY LIMITATIONS.md NEWS README README.md \
		README.Linux README.Linux-m68k README.Linux-PPC \
		RELEASE_NOTES VERSION || die

	if use java; then
		dodoc README.Java
	fi

	if use mono; then
		dodoc README.CSharp
	fi

	if use examples; then
		docinto samples
		dodoc samples/{*.m,README,Mmakefile}
		dodoc -r samples/c_interface \
			samples/diff \
			samples/muz \
			samples/rot13 \
			samples/solutions \
			samples/solver_types

		if use java; then
			dodoc -r samples/java_interface
		fi

		ecvs_clean "${D}"/usr/share/doc/${PF}/samples
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
