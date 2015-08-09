# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-r1

DESCRIPTION="Various tools to generate special DNS records like SSHFP, TLSA, OPENPGPKEY, IPSECKEY"
HOMEPAGE="http://people.redhat.com/pwouters/hash-slinger/"
SRC_URI="http://people.redhat.com/pwouters/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipsec +openpgp +ssh"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	dev-python/dnspython[$PYTHON_USEDEP]
	dev-python/ipaddr[$PYTHON_USEDEP]
	dev-python/m2crypto[$PYTHON_USEDEP]
	net-dns/unbound[python,$PYTHON_USEDEP]
	ipsec? ( net-misc/libreswan[dnssec] )
	openpgp? ( dev-python/python-gnupg[$PYTHON_USEDEP] )
	ssh? ( net-misc/openssh )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	local tools
	tools="tlsa"
	use ssh 	&& tools+=" sshfp"
	use openpgp && tools+=" openpgpkey"
	use ipsec 	&& tools+=" ipseckey"
	for tool in $tools ; do
		doman ${tool}.1
		python_foreach_impl python_doscript ${tool}
	done
	dodoc BUGS CHANGES README
}
