# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

MYP=maildrop-${PV}

DESCRIPTION="Mail delivery agent/filter"
HOMEPAGE="https://www.courier-mta.org/maildrop/"
SRC_URI="mirror://sourceforge/courier/${MYP}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="berkdb +gdbm"

RDEPEND="!mail-mta/courier
	!<=net-mail/courier-imap-5.2.3
	!<=mail-filter/maildrop-3.1.4
	!net-mail/courier-makedat
	>=net-libs/courier-unicode-2.0:=
	gdbm? ( >=sys-libs/gdbm-1.8.0:= )
	!gdbm? ( berkdb? ( >=sys-libs/db-3:= ) )"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( berkdb gdbm )"

S=${WORKDIR}/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	# Prefer gdbm over berkdb
	if use gdbm ; then
		use berkdb && elog "Both gdbm and berkdb selected. Using gdbm."
	fi

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-devel
	)

	if use gdbm ; then
		myeconfargs+=( --with-db=gdbm )
	else
		myeconfargs+=( --with-db=db )
	fi

	econf "${myeconfargs[@]}"
}
