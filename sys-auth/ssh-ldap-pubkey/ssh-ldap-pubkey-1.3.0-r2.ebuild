# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Utility to manage SSH public keys stored in LDAP"
HOMEPAGE="https://github.com/jirutka/ssh-ldap-pubkey"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/jirutka/${PN}/${PN}.git"

	inherit git-r3
else
	SRC_URI="https://github.com/jirutka/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
fi
PATCHES=( )
PATCH_COMMITS=(
	# https://github.com/jirutka/ssh-ldap-pubkey/pull/33/
	# config.parse_config: fix parsing of non-word characters
	130478a7532a8d3dfb0c8e3fbeac494908b8ec55
	# https://github.com/jirutka/ssh-ldap-pubkey/pull/33/
	# find_dn_by_login: handle complex filters
	8d718357dfa5a62f919e61cf620a862cae87e833
)
for c in "${PATCH_COMMITS[@]}" ; do
	d="${PN}-${c}.patch"
	PATCHES+=( "${DISTDIR}/${d}" )
	SRC_URI="${SRC_URI} https://github.com/jirutka/${PN}/commit/${c}.patch -> ${d}"
done

LICENSE="MIT"
SLOT="0"
IUSE="schema test"
RESTRICT="!test? ( test )"

MY_CDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	>=dev-python/python-ldap-3.0[${PYTHON_USEDEP}]
	virtual/logger"

DEPEND="
	${MY_CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-describe[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)"

# We need to block previous net-misc/openssh packages
# to avoid file collision on "/etc/openldap/schema/openssh-lpk.schema"
RDEPEND="${MY_CDEPEND}
	schema? ( !net-misc/openssh[ldap] )"

DOCS=( README.md CHANGELOG.adoc )

src_prepare() {
	sed -i -e 's/pyldap/python-ldap >= 3.0/' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	pytest -vv || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use schema; then
		insinto /etc/openldap/schema
		doins etc/openssh-lpk.schema
	fi

	local MY_DOCDIR="/usr/share/doc/${PF}/examples"
	insinto "${MY_DOCDIR}"
	doins etc/ldap.conf

	# We don't want to compress this small file to allow user
	# to diff configuration against upstream's default
	docompress -x "${MY_DOCDIR}"
}
