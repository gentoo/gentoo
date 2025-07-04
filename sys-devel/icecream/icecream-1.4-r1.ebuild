# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AT_NOELIBTOOLIZE="yes"
inherit autotools dot-a systemd tmpfiles

DESCRIPTION="Distributed compiler with a central scheduler to share build load"
HOMEPAGE="https://github.com/icecc/icecream"
SRC_URI="https://github.com/icecc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~loong ~ppc ~sparc ~x86"

DEPEND="app-arch/libarchive:=
	app-arch/zstd:=
	acct-user/icecream
	acct-group/icecream
	dev-libs/lzo:2
	sys-libs/libcap-ng"
RDEPEND="${DEPEND}
	dev-util/shadowman"
BDEPEND="app-text/docbook2X
	virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	lto-guarantee-fat

	econf \
		--enable-clang-rewrite-includes \
		--enable-clang-wrappers
}

src_install() {
	default

	strip-lto-bytecode

	find "${ED}" -name '*.la' -delete || die

	systemd_dounit "${FILESDIR}"/iceccd.service
	systemd_dounit "${FILESDIR}"/icecc-scheduler.service

	newconfd suse/sysconfig.icecream icecream
	newinitd "${FILESDIR}"/icecream.openrc icecream

	keepdir /var/log/icecream
	fowners icecream:icecream /var/log/icecream
	fperms 0750 /var/log/icecream

	newtmpfiles "${FILESDIR}"/icecream-tmpfiles.conf icecream.conf

	insinto /etc/logrotate.d
	newins suse/logrotate icecream

	insinto /etc/firewalld/services
	doins suse/iceccd.xml
	doins suse/icecc-scheduler.xml

	insinto /usr/share/shadowman/tools
	newins - icecc <<<"${EPREFIX}"/usr/libexec/icecc/bin
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && -z ${ROOT} ]] ; then
		eselect compiler-shadow remove icecc
	fi
}

pkg_postinst() {
	tmpfiles_process icecream.conf

	if [[ -z ${ROOT} ]] ; then
		eselect compiler-shadow update icecc
	fi
}
