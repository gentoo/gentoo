# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# For released versions, we precompile the man/html pages and store
# them in a tarball on our mirrors.  This avoids ugly issues while
# building stages, and reduces depedencies.
# To regenerate man/html pages emerge iputils-99999999[doc] with
# EGIT_COMMIT set to release tag and tar ${S}/doc folder.

EAPI="6"

inherit fcaps flag-o-matic meson systemd toolchain-funcs

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="https://github.com/iputils/iputils.git"
	inherit git-r3
else
	SRC_URI="https://github.com/iputils/iputils/archive/s${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~whissi/dist/iputils/${PN}-manpages-${PV}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/iputils"

LICENSE="BSD GPL-2+ rdisc"
SLOT="0"
IUSE="+arping caps clockdiff doc gcrypt idn ipv6 libressl nettle rarpd rdisc SECURITY_HAZARD ssl static tftpd tracepath traceroute6"

LIB_DEPEND="
	caps? ( sys-libs/libcap[static-libs(+)] )
	idn? ( net-dns/libidn2:=[static-libs(+)] )
	ipv6? (
		ssl? (
			gcrypt? ( dev-libs/libgcrypt:0=[static-libs(+)] )
			!gcrypt? (
				nettle? ( dev-libs/nettle[static-libs(+)] )
				!nettle? (
					libressl? ( dev-libs/libressl:0=[static-libs(+)] )
					!libressl? ( dev-libs/openssl:0=[static-libs(+)] )
				)
			)
		)
	)
"
RDEPEND="
	arping? ( !net-misc/arping )
	rarpd? ( !net-misc/rarpd )
	traceroute6? ( !net-analyzer/traceroute )
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
	virtual/os-headers
	virtual/pkgconfig
"
if [[ ${PV} == "99999999" ]] ; then
	DEPEND+="
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt:0
	"
fi

[ "${PV}" == "99999999" ] || S="${WORKDIR}/${PN}-s${PV}"

PATCHES=()

src_prepare() {
	use SECURITY_HAZARD && PATCHES+=( "${FILESDIR}"/${PN}-20150815-nonroot-floodping.patch )

	default
}

src_configure() {
	use static && append-ldflags -static

	local emesonargs=(
		-DUSE_CAP="$(usex caps true false)"
		-DUSE_IDN="$(usex idn true false)"
		-DBUILD_ARPING="$(usex arping true false)"
		-DBUILD_CLOCKDIFF="$(usex clockdiff true false)"
		-DBUILD_PING="true"
		-DBUILD_RARPD="$(usex rarpd true false)"
		-DBUILD_RDISC="$(usex rdisc true false)"
		-DENABLE_RDISC_SERVER="$(usex rdisc true false)"
		-DBUILD_TFTPD="$(usex tftpd true false)"
		-DBUILD_TRACEPATH="$(usex tracepath true false)"
		-DBUILD_TRACEROUTE6="$(usex ipv6 $(usex traceroute6 true false) false)"
		-DBUILD_NINFOD="false"
		-DNINFOD_MESSAGES="false"
		-DBUILD_HTML_MANS="$(usex doc true false)"
		-DUSE_SYSFS="$(usex arping true false)"
		-Dsystemdunitdir="$(systemd_get_systemunitdir)"
	)

	if use ipv6 && use ssl ; then
		emesonargs+=(
			-DUSE_CRYPTO="$(usex gcrypt gcrypt $(usex nettle nettle openssl))"
		)
	else
		emesonargs+=(
			-DUSE_CRYPTO="none"
		)
	fi

	if [[ "${PV}" != 99999999 ]] ; then
		emesonargs+=(
			-DBUILD_MANS="false"
		)
	fi

	meson_src_configure
}

src_compile() {
	tc-export CC
	meson_src_compile
}

src_install() {
	meson_src_install

	dodir /bin
	local my_bin
	for my_bin in $(usex arping arping '') ping ; do
		mv "${ED%/}"/usr/bin/${my_bin} "${ED%/}"/bin/ || die
	done
	dosym ping /bin/ping4

	if use tracepath ; then
		dosym tracepath /usr/bin/tracepath4
	fi

	if use ipv6 ; then
		dosym ping /bin/ping6

		if use tracepath ; then
			dosym tracepath /usr/bin/tracepath6
			dosym tracepath.8 /usr/share/man/man8/tracepath6.8
		fi
	fi

	if use doc ; then
		mv "${ED%/}"/usr/share/${PN} "${ED%/}"/usr/share/doc/${PF}/html || die
	fi
}

pkg_postinst() {
	fcaps cap_net_raw \
		bin/ping \
		$(usex arping 'bin/arping' '') \
		$(usex clockdiff 'usr/bin/clockdiff' '')
}
