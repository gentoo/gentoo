# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sandbox/sandbox-2.4.ebuild,v 1.12 2013/11/14 21:36:59 vapier Exp $

#
# don't monkey with this ebuild unless contacting portage devs.
# period.
#

inherit eutils flag-o-matic toolchain-funcs multilib unpacker

DESCRIPTION="sandbox'd LD_PRELOAD hack"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/sandbox/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	http://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd -x86-fbsd"
IUSE="multilib"

DEPEND="app-arch/xz-utils
	>=app-misc/pax-utils-0.1.19" #265376
RDEPEND=""

EMULTILIB_PKG="true"
has sandbox_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS="${EBUILD_DEATH_HOOKS} sandbox_death_notice"

sandbox_death_notice() {
	ewarn "If configure failed with a 'cannot run C compiled programs' error, try this:"
	ewarn "FEATURES=-sandbox emerge sandbox"
}

sb_get_install_abis() { use multilib && get_install_abis || echo ${ABI:-default} ; }

src_compile() {
	filter-lfs-flags #90228

	local OABI=${ABI}
	for ABI in $(sb_get_install_abis) ; do
		mkdir "${WORKDIR}/build-${ABI}"
		cd "${WORKDIR}/build-${ABI}"

		use multilib && multilib_toolchain_setup ${ABI}

		einfo "Configuring sandbox for ABI=${ABI}..."
		ECONF_SOURCE="../${P}/" \
		econf ${myconf} || die
		einfo "Building sandbox for ABI=${ABI}..."
		emake || die
	done
	ABI=${OABI}
}

src_test() {
	local OABI=${ABI}
	for ABI in $(sb_get_install_abis) ; do
		cd "${WORKDIR}/build-${ABI}"
		einfo "Checking sandbox for ABI=${ABI}..."
		emake check || die "make check failed for ${ABI}"
	done
	ABI=${OABI}
}

src_install() {
	local OABI=${ABI}
	for ABI in $(sb_get_install_abis) ; do
		cd "${WORKDIR}/build-${ABI}"
		einfo "Installing sandbox for ABI=${ABI}..."
		emake DESTDIR="${D}" install || die "make install failed for ${ABI}"
		insinto /etc/sandbox.d #333131
		doins etc/sandbox.d/00default || die
	done
	ABI=${OABI}

	doenvd "${FILESDIR}"/09sandbox

	keepdir /var/log/sandbox
	fowners root:portage /var/log/sandbox
	fperms 0770 /var/log/sandbox

	cd "${S}"
	dodoc AUTHORS ChangeLog* NEWS README
}

pkg_preinst() {
	chown root:portage "${D}"/var/log/sandbox
	chmod 0770 "${D}"/var/log/sandbox

	local old=$(find "${ROOT}"/lib* -maxdepth 1 -name 'libsandbox*')
	if [[ -n ${old} ]] ; then
		elog "Removing old sandbox libraries for you:"
		elog ${old//${ROOT}}
		find "${ROOT}"/lib* -maxdepth 1 -name 'libsandbox*' -exec rm -fv {} \;
	fi
}

pkg_postinst() {
	chmod 0755 "${ROOT}"/etc/sandbox.d #265376
}
