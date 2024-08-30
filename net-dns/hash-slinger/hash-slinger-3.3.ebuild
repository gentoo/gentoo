# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1

DESCRIPTION="Various tools to generate DNS records like SSHFP, TLSA, OPENPGPKEY, IPSECKEY"
HOMEPAGE="https://github.com/letoams/hash-slinger"
SRC_URI="https://github.com/letoams/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ipsec +openpgp +ssh"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dnspython[${PYTHON_USEDEP}]
		dev-python/ipaddr[${PYTHON_USEDEP}]
		dev-python/m2crypto[${PYTHON_USEDEP}]
	')
	net-dns/unbound[python,${PYTHON_SINGLE_USEDEP}]
	ipsec? ( net-vpn/libreswan[dnssec] )
	openpgp? ( $(python_gen_cond_dep 'dev-python/python-gnupg[${PYTHON_USEDEP}]') )
	ssh? ( virtual/openssh )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.3-fix-tlsa-record-generation.patch"
	"${FILESDIR}/${PN}-3.3-python-3.12.patch"
)

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
