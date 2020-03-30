# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic rpm toolchain-funcs user

MY_P=${P%.*}-${PV##*.}

DESCRIPTION="App that allows non-privileged apps to write utmp (login) info"
HOMEPAGE="https://www.redhat.com/"
SRC_URI="mirror://gentoo/${MY_P}.src.rpm"

LICENSE="|| ( MIT LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="
	!sys-libs/libutempter
	!dev-python/utmp"

S=${WORKDIR}/${P%.*}
PATCHES=(
	"${FILESDIR}"/${P}-no_utmpx.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
)

pkg_setup() {
	enewgroup utmp 406
}

src_configure() {
	tc-export CC
	append-cflags -Wall
}

src_install() {
	emake \
		RPM_BUILD_ROOT="${ED}" \
		LIBDIR=/usr/$(get_libdir) \
		install
	dobin utmp

	fowners root:utmp /usr/sbin/utempter
	fperms 2755 /usr/sbin/utempter
}

pkg_postinst() {
	if [[ -f "${EROOT%/}"/var/log/wtmp ]] ; then
		chown root:utmp "${EROOT%/}"/var/log/wtmp
		chmod 664 "${EROOT%/}"/var/log/wtmp
	fi
	if [[ -f "${EROOT%/}"/var/run/utmp ]] ; then
		chown root:utmp "${EROOT%/}"/var/run/utmp
		chmod 664 "${EROOT%/}"/var/run/utmp
	fi
}
