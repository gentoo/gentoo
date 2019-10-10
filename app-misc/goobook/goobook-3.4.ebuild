# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 readme.gentoo-r1

DESCRIPTION="Access your Google contacts from the command line"
HOMEPAGE="https://gitlab.com/goobook/goobook"
SRC_URI="mirror://pypi/g/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/google-api-python-client-1.6.4[${PYTHON_USEDEP}]"
# dev-python/{simplejson,oauth2client} are deps for the above

DEPEND="${PYTHON_DEPS}"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
To setup initial authentication, execute:

~ $ goobook authenticate

If you want to use goobook from mutt, add this in your .muttrc file:
	set query_command=\"goobook query '%s'\"
to query address book.

You may find more information and advanced configuration tips at
https://pypi.org/project/${PN}/${PV} in \"Configure/Mutt\" section"

src_install() {
	distutils-r1_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
