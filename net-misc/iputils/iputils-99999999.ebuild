# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="de fr ja pt_BR tr uk zh_CN"

inherit fcaps meson plocale systemd toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/iputils/iputils.git"
	inherit git-r3
else
	SRC_URI="https://github.com/iputils/iputils/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iputils"

# We install ping unconditionally so BSD is listed by itself
# See LICENSE on each release, it summaries per-component
LICENSE="
	BSD
	arping? ( GPL-2+ )
	clockdiff? ( BSD )
	tracepath? ( GPL-2+ )
"
SLOT="0"
IUSE="+arping caps clockdiff doc idn nls test tracepath"
RESTRICT="!test? ( test )"

RDEPEND="
	caps? ( sys-libs/libcap )
	idn? ( net-dns/libidn2:= )
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
BDEPEND="
	virtual/pkgconfig
	test? ( sys-apps/iproute2 )
	nls? ( sys-devel/gettext )
"

if [[ ${PV} == 9999 ]] ; then
	BDEPEND+="
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-ns-stylesheets
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	"
fi

src_prepare() {
	default

	plocale_get_locales > po/LINGUAS || die
}

src_configure() {
	local emesonargs=(
		-DUSE_CAP=$(usex caps true false)
		-DUSE_IDN=$(usex idn true false)
		-DBUILD_ARPING=$(usex arping true false)
		-DBUILD_CLOCKDIFF=$(usex clockdiff true false)
		-DBUILD_PING=true
		-DBUILD_TRACEPATH=$(usex tracepath true false)
		-DNO_SETCAP_OR_SUID=true
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		-DUSE_GETTEXT=$(usex nls true false)
		$(meson_use !test SKIP_TESTS)
	)

	if use doc || [[ ${PV} == 9999 ]] ; then
		emesonargs+=(
			-DBUILD_HTML_MANS=true
			-DBUILD_MANS=true
		)
	fi

	meson_src_configure
}

src_compile() {
	tc-export CC

	meson_src_compile
}

src_test() {
	if [[ ${EUID} != 0 ]] ; then
		einfo "Tests require root privileges. Skipping ..."
		return
	fi

	meson_src_test
}

src_install() {
	meson_src_install

	FILECAPS=( cap_net_raw usr/bin/ping )
	use arping && FILECAPS+=( usr/bin/arping )
	use clockdiff && FILECAPS+=( usr/bin/clockdiff )

	dosym ping /usr/bin/ping4
	dosym ping /usr/bin/ping6

	if use tracepath ; then
		dosym tracepath /usr/bin/tracepath4
		dosym tracepath /usr/bin/tracepath6
		dosym tracepath.8 /usr/share/man/man8/tracepath4.8
		dosym tracepath.8 /usr/share/man/man8/tracepath6.8
	fi

	if use doc ; then
		mv "${ED}"/usr/share/${PN} "${ED}"/usr/share/doc/${PF}/html || die
	fi
}

pkg_preinst() {
	local version_with_tftpd="<${CATEGORY}/${PN}-20211215"
	if has_version "${version_with_tftpd}[traceroute6]" || has_version "${version_with_tftpd}[tftpd]" ; then
		HAD_TFTPD_VERSION=1
	fi
}

pkg_postinst() {
	fcaps_pkg_postinst

	if [[ ${HAD_TFTPD_VERSION} -eq 1 ]] ; then
		ewarn "This upstream version (>= 20211215) drops two tools:"
		ewarn "1. tftpd (alternatives: net-ftp/tftp-hpa, net-dns/dnsmasq)"
		ewarn "2. traceroute6 (alternatives: net-analyzer/mtr, net-analyzer/traceroute)"
		ewarn "Please install one of the listed alternatives if needed!"
	fi
}
