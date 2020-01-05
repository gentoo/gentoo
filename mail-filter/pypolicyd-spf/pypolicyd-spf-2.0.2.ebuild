# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

# The built-in ipaddress module handles the parsing of IP addresses. If
# python is built without ipv6 support, then ipaddress can't parse ipv6
# addresses, and the daemon will crash if it sees an ipv6 SPF record. In
# other words, it's completely broken.
PYTHON_REQ_USE="ipv6"

inherit distutils-r1

DESCRIPTION="Python-based policy daemon for Postfix SPF verification"
HOMEPAGE="https://launchpad.net/${PN}"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/pyspf[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	dev-python/authres[${PYTHON_USEDEP}]"

DOCS=( CHANGES policyd-spf.conf.commented README README.per_user_whitelisting )

python_prepare_all() {
	# The "real" config file mentions the commented one, so we point
	# users in the right direction.
	local oldconf="policyd-spf.conf.commented"
	local newconf="/usr/share/doc/${PF}/${oldconf}"

	sed -i "1 s~ ${oldconf}~,\n#  ${newconf}~" policyd-spf.conf \
		|| die 'failed to update commented config file path'

	distutils-r1_python_prepare_all
}
