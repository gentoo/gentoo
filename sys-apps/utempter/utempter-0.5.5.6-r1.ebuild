# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${P%.*}"
MY_P="${MY_PN}-${PV##*.}"

inherit flag-o-matic rpm toolchain-funcs

DESCRIPTION="App that allows non-privileged apps to write utmp (login) info"
HOMEPAGE="https://www.redhat.com/"
SRC_URI="mirror://gentoo/${MY_P}.src.rpm"
S="${WORKDIR}/${MY_PN}"

LICENSE="|| ( MIT LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="acct-group/utmp"
RDEPEND="
	${BDEPEND}
	!sys-libs/libutempter
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.5.6-no_utmpx.patch
	"${FILESDIR}"/${PN}-0.5.5.6-fix-build-system.patch
)

src_prepare() {
	default
	tc-export CC
	append-cflags -Wall
}

src_install() {
	local myemakeargs=(
		LIBDIR="/usr/$(get_libdir)"
		RPM_BUILD_ROOT="${ED}"
	)

	emake "${myemakeargs[@]}" install

	dobin utmp

	fowners root:utmp /usr/sbin/utempter
	fperms 2755 /usr/sbin/utempter
}
