# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# don't monkey with this ebuild unless contacting portage devs.
# period.
#

inherit eutils flag-o-matic toolchain-funcs multilib unpacker multiprocessing

DESCRIPTION="sandbox'd LD_PRELOAD hack"
HOMEPAGE="https://www.gentoo.org/proj/en/portage/sandbox/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
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

sb_foreach_abi() {
	local OABI=${ABI}
	for ABI in $(sb_get_install_abis) ; do
		cd "${WORKDIR}/build-${ABI}"
		einfo "Running $1 for ABI=${ABI}..."
		"$@"
	done
	ABI=${OABI}
}

src_unpack() {
	unpacker
	cd "${S}"
	epatch "${FILESDIR}"/${P}-memory-corruption.patch #568714
	epatch_user
}

sb_configure() {
	mkdir "${WORKDIR}/build-${ABI}"
	cd "${WORKDIR}/build-${ABI}"

	use multilib && multilib_toolchain_setup ${ABI}

	einfo "Configuring sandbox for ABI=${ABI}..."
	ECONF_SOURCE="${S}" \
	econf ${myconf} || die
}

sb_compile() {
	emake || die
}

src_compile() {
	filter-lfs-flags #90228

	# Run configures in parallel!
	multijob_init
	local OABI=${ABI}
	for ABI in $(sb_get_install_abis) ; do
		multijob_child_init sb_configure
	done
	ABI=${OABI}
	multijob_finish

	sb_foreach_abi sb_compile
}

sb_test() {
	emake check TESTSUITEFLAGS="--jobs=$(makeopts_jobs)" || die
}

src_test() {
	sb_foreach_abi sb_test
}

sb_install() {
	emake DESTDIR="${D}" install || die
	insinto /etc/sandbox.d #333131
	doins etc/sandbox.d/00default || die
}

src_install() {
	sb_foreach_abi sb_install

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
