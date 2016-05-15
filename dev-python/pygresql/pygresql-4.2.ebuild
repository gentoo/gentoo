# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

POSTGRES_COMPAT=( 9.{0,1,2,3,4,5} )
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="PyGreSQL-${PV}"

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="http://www.pygresql.org/"
SRC_URI="mirror://pypi/P/PyGreSQL/${MY_P}.zip"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="doc"

DEPEND="|| (
	dev-db/postgresql:9.5
	dev-db/postgresql:9.4
	dev-db/postgresql:9.3
	dev-db/postgresql:9.2
	dev-db/postgresql:9.1
	dev-db/postgresql:9.0
)"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# Verify that the currently selected PostgreSQL slot is set to one of
# the slots defined in POSTGRES_COMPAT.
postgres_check_slot() {
	if ! declare -p POSTGRES_COMPAT &>/dev/null; then
		die 'POSTGRES_COMPAT not declared.'
	fi

# Don't die because we can't run postgresql-config during pretend.
[[ "$EBUILD_PHASE" = "pretend" && -z "$(which postgresql-config 2> /dev/null)" ]] \
	&& return 0

	local res=$(echo ${POSTGRES_COMPAT[@]} \
		| grep -c $(postgresql-config show 2> /dev/null) 2> /dev/null)

	if [[ "$res" -eq "0" ]] ; then
			eerror "PostgreSQL slot must be set to one of: "
			eerror "    ${POSTGRES_COMPAT[@]}"
			return 1
	fi

	return 0
}

pkg_pretend() {
	postgres_check_slot
}

pkg_setup() {
	postgres_check_slot || die
}

python_install_all() {
	local DOCS=( docs/*.rst )
	distutils-r1_python_install_all

	if use doc; then
		insinto /usr/share/doc/${PF}/tutorial
		doins tutorial/*
		dohtml docs/*.{html,css}
	fi
}
