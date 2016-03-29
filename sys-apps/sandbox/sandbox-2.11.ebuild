# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

#
# don't monkey with this ebuild unless contacting portage devs.
# period.
#

EAPI="5"

inherit eutils flag-o-matic multilib-minimal multiprocessing pax-utils

DESCRIPTION="sandbox'd LD_PRELOAD hack"
HOMEPAGE="https://www.gentoo.org/proj/en/portage/sandbox/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="app-arch/xz-utils
	>=app-misc/pax-utils-0.1.19" #265376
RDEPEND=""

has sandbox_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS="${EBUILD_DEATH_HOOKS} sandbox_death_notice"

sandbox_death_notice() {
	ewarn "If configure failed with a 'cannot run C compiled programs' error, try this:"
	ewarn "FEATURES=-sandbox emerge sandbox"
}

src_prepare() {
	epatch_user
}

multilib_src_configure() {
	filter-lfs-flags #90228

	local myconf=()
	host-is-pax && myconf+=( --disable-pch ) #301299 #425524 #572092

	ECONF_SOURCE="${S}" \
	econf "${myconf[@]}"
}

multilib_src_test() {
	# Default sandbox build will run with --jobs set to # cpus.
	emake check TESTSUITEFLAGS="--jobs=$(makeopts_jobs)"
}

multilib_src_install_all() {
	doenvd "${FILESDIR}"/09sandbox

	keepdir /var/log/sandbox
	fowners root:portage /var/log/sandbox
	fperms 0770 /var/log/sandbox

	cd "${S}"
	dodoc AUTHORS ChangeLog* NEWS README
}

pkg_preinst() {
	chown root:portage "${ED}"/var/log/sandbox
	chmod 0770 "${ED}"/var/log/sandbox

	if [[ ${REPLACING_VERSIONS} == 1.* ]] ; then
		local old=$(find "${EROOT}"/lib* -maxdepth 1 -name 'libsandbox*')
		if [[ -n ${old} ]] ; then
			elog "Removing old sandbox libraries for you:"
			find "${EROOT}"/lib* -maxdepth 1 -name 'libsandbox*' -print -delete
		fi
	fi
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} == 1.* ]] ; then
		chmod 0755 "${EROOT}"/etc/sandbox.d #265376
	fi
}
