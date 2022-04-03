# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For released versions, we precompile the man/html pages and store
# them in a tarball on our mirrors.  This avoids ugly issues while
# building stages, and reduces dependencies.
# To regenerate man/html pages emerge iputils-99999999[doc] with
# EGIT_COMMIT set to release tag, all USE flags enabled and
# tar ${S}/doc folder.

EAPI="7"

PLOCALES="de fr ja pt_BR tr uk zh_CN"

inherit fcaps flag-o-matic meson plocale systemd toolchain-funcs

if [[ ${PV} == 99999999 ]] ; then
	EGIT_REPO_URI="https://github.com/iputils/iputils.git"
	inherit git-r3
else
	SRC_URI="https://github.com/iputils/iputils/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-manpages-${PV}.tar.xz
		https://dev.gentoo.org/~whissi/dist/iputils/${PN}-manpages-${PV}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iputils"

LICENSE="BSD GPL-2+ rdisc"
SLOT="0"
IUSE="+arping caps clockdiff doc gcrypt idn nettle nls ssl static test tracepath"
RESTRICT="!test? ( test )"

LIB_DEPEND="
	caps? ( sys-libs/libcap[static-libs(+)] )
	idn? ( net-dns/libidn2:=[static-libs(+)] )
	nls? ( virtual/libintl[static-libs(+)] )
"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="
	${RDEPEND}
	virtual/os-headers
	static? ( ${LIB_DEPEND} )
"
BDEPEND="
	virtual/pkgconfig
	test? ( sys-apps/iproute2 )
	nls? ( sys-devel/gettext )
"

if [[ ${PV} == 99999999 ]] ; then
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
	use static && append-ldflags -static

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

	if [[ ${PV} == 99999999 ]] ; then
		emesonargs+=(
			-DBUILD_HTML_MANS=$(usex doc true false)
			-DBUILD_MANS=true
		)
	else
		emesonargs+=(
			-DBUILD_HTML_MANS=false
			-DBUILD_MANS=false
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

	dodir /bin
	local my_bin
	for my_bin in $(usex arping arping '') ping ; do
		mv "${ED}"/usr/bin/${my_bin} "${ED}"/bin/ || die
	done
	dosym ping /bin/ping4
	dosym ping /bin/ping6

	if use tracepath ; then
		dosym tracepath /usr/bin/tracepath4
		dosym tracepath /usr/bin/tracepath6
		dosym tracepath.8 /usr/share/man/man8/tracepath6.8
	fi

	if [[ ${PV} != 99999999 ]] ; then
		local -a man_pages
		local -a html_man_pages

		while IFS= read -r -u 3 -d $'\0' my_bin
		do
			my_bin=$(basename "${my_bin}")
			[[ -z "${my_bin}" ]] && continue

			if [[ -f "${S}/doc/${my_bin}.8" ]] ; then
				man_pages+=( ${my_bin}.8 )
			fi

			if [[ -f "${S}/doc/${my_bin}.html" ]] ; then
				html_man_pages+=( ${my_bin}.html )
			fi
		done 3< <(find "${ED}"/{bin,usr/bin,usr/sbin} -type f -perm -a+x -print0 2>/dev/null)

		pushd doc &>/dev/null || die
		doman "${man_pages[@]}"
		if use doc ; then
			docinto html
			dodoc "${html_man_pages[@]}"
		fi
		popd &>/dev/null || die
	else
		if use doc ; then
			mv "${ED}"/usr/share/${PN} "${ED}"/usr/share/doc/${PF}/html || die
		fi
	fi
}

pkg_preinst() {
	local version_with_tftpd="<${CATEGORY}/${PN}-20211215"
	if has_version "${version_with_tftpd}[traceroute6]" || has_version "${version_with_tftpd}[tftpd]" ; then
		HAD_TFTPD_VERSION=1
	fi
}

pkg_postinst() {
	if [[ ${HAD_TFTPD_VERSION} -eq 1 ]] ; then
		ewarn "This upstream version (>= 20211215) drops two tools:"
		ewarn "1. tftpd (alternatives: net-ftp/tftp-hpa, net-dns/dnsmasq)"
		ewarn "2. traceroute6 (alternatives: net-analyzer/mtr, net-analyzer/traceroute)"
		ewarn "Please install one of the listed alternatives if needed!"
	fi

	fcaps cap_net_raw \
		bin/ping \
		$(usex arping 'bin/arping' '') \
		$(usex clockdiff 'usr/bin/clockdiff' '')
}
