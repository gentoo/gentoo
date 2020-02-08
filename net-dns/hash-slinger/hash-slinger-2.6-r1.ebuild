# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

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
	net-dns/unbound[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/dnspython[${PYTHON_MULTI_USEDEP}]
		dev-python/ipaddr[${PYTHON_MULTI_USEDEP}]
		dev-python/m2crypto[${PYTHON_MULTI_USEDEP}]
		openpgp? ( dev-python/python-gnupg[${PYTHON_MULTI_USEDEP}] )
	')
	ipsec? ( net-vpn/libreswan[dnssec] )
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
		python_doscript ${tool}
	done
	dodoc BUGS CHANGES README
}
