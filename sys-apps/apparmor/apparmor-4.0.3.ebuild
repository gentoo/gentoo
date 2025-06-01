# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd toolchain-funcs linux-info

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Userspace utils and init scripts for the AppArmor application security system"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
SRC_URI="https://launchpad.net/${PN}/${MY_PV}/${PV}/+download/${PN}-${PV}.tar.gz"
S=${WORKDIR}/apparmor-${PV}/parser

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv"
IUSE="doc"

# Was restricted previously b/c needs apparmor support in kernel
# TODO: add check to ebuild
#RESTRICT="test" # bug 675854

RDEPEND="~sys-libs/libapparmor-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	sys-apps/which
	app-alternatives/yacc
	sys-devel/gettext
	app-alternatives/lex
	doc? ( dev-tex/latex2html )
"
CONFIG_CHECK="SECURITY_APPARMOR"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.3-convert-uint-to-unsigned-int.patch"
)

src_prepare() {
	default

	sed -e '/^AALIB =/ s/-Bstatic/-Bdynamic/' -i Makefile || die

	# Install rc.apparmor.functions to Gentoo-appropriate location
	sed -e '/install-indep: indep/a\\tinstall -m 755 -d ${DESTDIR}/usr/libexec' -i Makefile || die
	sed -e 's:rc.apparmor.functions $(APPARMOR_BIN_PREFIX):rc.apparmor.functions ${DESTDIR}/usr/libexec:' \
		-i Makefile || die
	sed -e ':^APPARMOR_FUNCTIONS=: s:/lib/apparmor/:/usr/libexec/:' -i apparmor.systemd || die
	sed -e 's:\. /lib/apparmor/rc.apparmor.functions:\. /usr/libexec/rc.apparmor.functions:' -i profile-load || die

	# remove warning about missing file that controls features
	# we don't currently support
	sed -e "/installation problem/ctrue" -i rc.apparmor.functions || die

	# bug 634782
	sed -e "s/cpp/$(tc-getCPP) -/" \
		-i ../common/list_capabilities.sh \
		-i ../common/list_af_names.sh || die
}

src_configure() {
	# ODR violations (bug #863524)
	filter-lto

	default
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCPP) -" \
		CXX="$(tc-getCXX)" \
		USE_SYSTEM=1 \
		arch manpages
	use doc && emake pdf
}

src_test() {
	emake CXX="$(tc-getCXX)" USE_SYSTEM=1 check
}

src_install() {
	emake \
		CPP="$(tc-getCPP) -" \
		DESTDIR="${D}" \
		DISTRO="unknown" \
		USE_SYSTEM=1 \
		install

	dodir /etc/apparmor.d/disable

	newinitd "${FILESDIR}/${PN}-init-1" ${PN}
	systemd_newunit "${FILESDIR}/apparmor.service" apparmor.service

	use doc && dodoc techdoc.pdf

	exeinto /usr/share/apparmor
	doexe "${FILESDIR}/apparmor_load.sh"
	doexe "${FILESDIR}/apparmor_unload.sh"
}
