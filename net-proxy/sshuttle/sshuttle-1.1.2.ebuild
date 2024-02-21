# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-sshuttle-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${SSHUTTLE_DOCS_PREBUILT:=1}

SSHUTTLE_DOCS_PREBUILT_DEV=sam
SSHUTTLE_DOCS_VERSION=${PV}
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
SSHUTTLE_DOCS_USEFLAG="+doc"

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 linux-info

DESCRIPTION="Transparent proxy server that works as a poor man's VPN using ssh"
HOMEPAGE="https://github.com/sshuttle/sshuttle https://pypi.org/project/sshuttle/"
# No tests in sdist
SRC_URI=" https://github.com/sshuttle/sshuttle/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
if [[ ${SSHUTTLE_DOCS_PREBUILT} == 1 ]] ; then
	SRC_URI+=" !doc? ( https://dev.gentoo.org/~${SSHUTTLE_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${SSHUTTLE_DOCS_VERSION}-docs.tar.xz )"
	SSHUTTLE_DOCS_USEFLAG="doc"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${SSHUTTLE_DOCS_USEFLAG}"

BDEPEND="
	doc? (
		dev-python/sphinx
		dev-python/furo
	)
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
	|| ( net-firewall/iptables net-firewall/nftables )
"

CONFIG_CHECK="~NETFILTER_XT_TARGET_HL ~IP_NF_TARGET_REDIRECT ~IP_NF_MATCH_TTL ~NF_NAT"

distutils_enable_tests pytest

python_prepare_all() {
	# Don't run tests via setup.py pytest
	sed -i "/setup_requires=/s/'pytest-runner'//" setup.py || die

	# Don't require pytest-cov when running tests
	sed -i "s/^addopts =/#\0/" setup.cfg || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc ; then
		emake -j1 -C docs html man
	fi
}

python_install_all() {
	# If USE=doc, there'll be newly generated docs which we install instead.
	if ! use doc && [[ ${SSHUTTLE_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${SSHUTTLE_DOCS_VERSION}-docs/sshuttle.1
	else
		HTML_DOCS=( docs/_build/html/. )
		doman docs/_build/man/*
	fi

	distutils-r1_python_install_all
}
