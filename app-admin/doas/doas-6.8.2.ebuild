# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=OpenDoas
MY_P=${MY_PN}-${PV}
DESCRIPTION="Run commands as super/another user (alt sudo) (unofficial port from OpenBSD)"
HOMEPAGE="https://github.com/Duncaen/OpenDoas"
SRC_URI="https://github.com/Duncaen/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="pam persist"

BDEPEND="virtual/yacc"
RDEPEND="pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CC AR

	./configure \
		--prefix="${EPREFIX}"/usr \
		--sysconfdir="${EPREFIX}"/etc \
		$(use_with pam) \
		$(use_with persist timestamp) \
	|| die "Configure failed"
}

pkg_postinst() {
	if use persist ; then
		ewarn "The persist/timestamp feature is disabled by default upstream."
		ewarn "It may not be as secure as on OpenBSD where proper kernel support exists."
	fi

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "By default, doas will deny all actions."
		elog "You need to create your own custom configuration at ${EROOT}/etc/doas.conf."
		elog "See https://wiki.gentoo.org/wiki/Doas for guidance."
	fi
}
