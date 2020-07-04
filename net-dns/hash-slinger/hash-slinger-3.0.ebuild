# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1

DESCRIPTION="Various tools to generate DNS records like SSHFP, TLSA, OPENPGPKEY, IPSECKEY"
HOMEPAGE="https://github.com/letoams/hash-slinger"
SRC_URI="https://people.redhat.com/pwouters/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/letoams/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ipsec +openpgp +ssh"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dnspython[${PYTHON_MULTI_USEDEP}]
		dev-python/ipaddr[${PYTHON_MULTI_USEDEP}]
		dev-python/m2crypto[${PYTHON_MULTI_USEDEP}]
	')
	net-dns/unbound[python,${PYTHON_SINGLE_USEDEP}]
	ipsec? ( net-vpn/libreswan[dnssec] )
	openpgp? ( $(python_gen_cond_dep 'dev-python/python-gnupg[${PYTHON_MULTI_USEDEP}]') )
	ssh? ( net-misc/openssh )
"

src_install() {
	local tools tool
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
