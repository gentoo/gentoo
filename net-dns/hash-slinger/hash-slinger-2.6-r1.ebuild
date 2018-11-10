# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Various tools to generate special DNS records like SSHFP, TLSA, OPENPGPKEY, IPSECKEY"
HOMEPAGE="https://people.redhat.com/pwouters/hash-slinger/"
SRC_URI="https://people.redhat.com/pwouters/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipsec +openpgp +ssh"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	dev-python/ipaddr[$PYTHON_USEDEP]
	dev-python/m2crypto[$PYTHON_USEDEP]
	net-dns/unbound[python,$PYTHON_USEDEP]
	virtual/python-dnspython[$PYTHON_USEDEP]
	ipsec? ( net-vpn/libreswan[dnssec] )
	openpgp? ( dev-python/python-gnupg[$PYTHON_USEDEP] )
	ssh? ( net-misc/openssh )
"

src_install() {
	local tools
	tools="tlsa"
	use ssh	&& tools+=" sshfp"
	use openpgp && tools+=" openpgpkey"
	use ipsec && tools+=" ipseckey"
	for tool in $tools ; do
		doman ${tool}.1
		python_foreach_impl python_doscript ${tool}
	done
	dodoc BUGS CHANGES README
}
