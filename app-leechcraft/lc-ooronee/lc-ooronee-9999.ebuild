# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit leechcraft

DESCRIPTION="Quark handling text and images droppend onto it"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
	virtual/leechcraft-quark-sideprovider
"

# Grabbed from net-misc/netctl ebuild.
optfeature() {
	local desc=$1
	shift
	while (( $# )); do
		if has_version "$1"; then
			elog "  [I] $1 to ${desc}"
		else
			elog "  [ ] $1 to ${desc}"
		fi
		shift
	done
}

pkg_postinst() {
	elog "Install at least some of the following additional LeechCraft modules for Ooronee to be useful:"
	optfeature "upload images" app-leechcraft/lc-imgaste app-leechcraft/lc-blasq
	optfeature "search via OpenSearch" app-leechcraft/lc-seekthru
	optfeature "search via Google" app-leechcraft/lc-pogooglue
}
