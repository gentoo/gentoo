# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Super-useful stream editor"
HOMEPAGE="http://sed.sourceforge.net/"
SRC_URI="mirror://gnu/sed/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="acl nls selinux static"

RDEPEND="acl? ( virtual/acl )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

#PATCHES=(
#)

src_bootstrap_sed() {
	# make sure system-sed works #40786
	if ! type -p sed > /dev/null ; then
		mkdir -p "${T}/bootstrap"
		printf '#!/bin/sh\nexec busybox sed "$@"\n' > "${T}/bootstrap/sed" || die
		chmod a+rx "${T}/bootstrap/sed"
		PATH="${T}/bootstrap:${PATH}"
	fi
}

src_prepare() {
	#epatch "${PATCHES[@]}"

	# don't use sed before bootstrap if we have to recover a broken host sed
	src_bootstrap_sed
}

src_configure() {
	local myconf=()
	if use userland_GNU; then
		myconf+=( --exec-prefix="${EPREFIX}" )
	else
		myconf+=( --program-prefix=g )
	fi

	export ac_cv_search_setfilecon=$(usex selinux -lselinux)
	export ac_cv_header_selinux_{context,selinux}_h=$(usex selinux)
	use static && append-ldflags -static
	myconf+=(
		$(use_enable acl)
		$(use_enable nls)
	)
	econf "${myconf[@]}"
}
