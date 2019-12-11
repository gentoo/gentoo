# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils perl-module linux-info python-single-r1

DESCRIPTION="High-level language bindings for libnetfilter_queue"
HOMEPAGE="https://github.com/chifflier/nfqueue-bindings"
SRC_URI="https://github.com/chifflier/nfqueue-bindings/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="perl python examples"
REQUIRED_USE="|| ( perl python ) python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? (
		dev-python/dpkt[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	perl? ( dev-lang/perl )
	net-libs/libnetfilter_queue
	dev-lang/swig"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	# At least one of Python or Perl must be selected
	use python || useq perl || die "At least one supported language must be selected."
	# Check kernel configuration for NFQUEUE
	if linux_config_exists; then
		ebegin "Checking NETFILTER_NETLINK_QUEUE support"
		linux_chkconfig_present NETFILTER_NETLINK_QUEUE
		eend $? || \
			eerror 'Netfilter NFQUEUE over NFNETLINK interface support not found!'
		ebegin "Checking NETFILTER_XT_TARGET_NFQUEUE support"
		linux_chkconfig_present NETFILTER_XT_TARGET_NFQUEUE
		eend $? || \
			eerror '"NFQUEUE" target Support not found!'
	fi
}

src_prepare() {
	if use perl; then
		# Fix Perl destination directory
		perl_set_version
		sed -i "s|\${LIB_INSTALL_DIR}/perl\${PERL_VERSION}/|${VENDOR_ARCH}|" perl/CMakeLists.txt || die
	else
		sed -i 's|ADD_SUBDIRECTORY(perl)||' CMakeLists.txt || die
	fi

	if use python; then
		sed -i "s|\${LIB_INSTALL_DIR}/python\${PYTHON_VERSION}/dist-packages/|$(python_get_sitedir)|" python/CMakeLists.txt || die
	else
		sed -i 's|ADD_SUBDIRECTORY(python)||' CMakeLists.txt || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install PREFIX=/usr
	docinto examples
	use examples && dodoc examples/*
}
