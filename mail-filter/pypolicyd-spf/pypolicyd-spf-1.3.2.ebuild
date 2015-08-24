# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

# With >=python-3.3, the built-in ipaddress module handles the parsing
# of IP addresses. If python is built without ipv6 support, then
# ipaddress can't parse ipv6 addresses, and the daemon will crash if it
# sees an ipv6 SPF record. In other words, it's completely broken.
#
# Ideally this would remain optional for python-2.x, but until there's
# an easy way to do that, "maybe annoying" seems a better option than
# "maybe broken."
PYTHON_REQ_USE="ipv6"

inherit distutils-r1

DESCRIPTION="Python-based policy daemon for Postfix SPF verification"
HOMEPAGE="https://launchpad.net/${PN}"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# ipaddr is only needed with <python-3.3.
#
# The lower bound on pyspf is not strictly necessary, but some features
# are silently disabled with older versions of pyspf.
#
DEPEND="$(python_gen_cond_dep \
			'>=dev-python/ipaddr-2.1.10[${PYTHON_USEDEP}]' \
			'python2*')
	>=dev-python/pyspf-2.0.9[${PYTHON_USEDEP}]"

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
