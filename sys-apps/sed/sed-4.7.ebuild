# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Super-useful stream editor"
HOMEPAGE="http://sed.sourceforge.net/"
SRC_URI="mirror://gnu/sed/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
IUSE="acl forced-sandbox nls selinux static"

RDEPEND="acl? ( virtual/acl )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_bootstrap_sed() {
	# make sure system-sed works #40786 #650052
	if ! type -p sed > /dev/null || has_version 'sys-apps/sed[forced-sandbox]' ; then
		mkdir -p "${T}/bootstrap"
		printf '#!/bin/sh\nexec busybox sed "$@"\n' > "${T}/bootstrap/sed" || die
		chmod a+rx "${T}/bootstrap/sed"
		PATH="${T}/bootstrap:${PATH}"
	fi
}

src_prepare() {
	# Don't use sed before bootstrap if we have to recover a broken host sed.
	src_bootstrap_sed

	default

	if use forced-sandbox ; then
		# Upstream doesn't want to add a configure flag for this.
		# https://lists.gnu.org/archive/html/bug-sed/2018-03/msg00001.html
		sed -i \
			-e '/^bool sandbox = false;/s:false:true:' \
			sed/sed.c || die
		# Make sure the sed took.
		grep -q '^bool sandbox = true;' sed/sed.c || die "forcing sandbox failed"
	fi
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
