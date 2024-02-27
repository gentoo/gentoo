# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Fast and small Bayesian spam filter"
HOMEPAGE="https://sourceforge.net/projects/bmf/"
SRC_URI="mirror://sourceforge/bmf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mysql berkdb"

DEPEND="
	mysql? ( dev-db/mysql-connector-c:0= )
	berkdb? ( >=sys-libs/db-3.2.9:= )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_QA.patch" )

src_prepare() {
	# respect CFLAGS/LDFLAGS/CC
	sed -i \
		-e '/D_LINUX/s/CFLAGS="$CCDBG/CFLAGS+=" $CCDBG/' \
		-e 's/LDFLAGS="$LDDBG/LDFLAGS+=" $LDDBG/' \
		-e "s/CC=gcc/CC=$(tc-getCC)/" \
		"${S}/configure" || die

	# include mysql headers
	sed -i -e '/HAVE_MYSQL/s/HAVE_MYSQL/HAVE_MYSQL `mysql_config --include`/' \
		"${S}/configure" || die

	# We don't need to be root to run install
	sed -i -e 's/install: checkroot bmf/install: bmf/' Makefile.in || die

	default
}

src_configure() {
	# this is not an autotools script
	./configure \
		$(use_with mysql) \
		$(use_with berkdb libdb) || die
}

pkg_postinst() {
	elog
	elog "Important: Remember to train bmf before you start using it."
	elog "See the README file for further instructions on training and using bmf"
	elog "with procmail."
	elog
}
