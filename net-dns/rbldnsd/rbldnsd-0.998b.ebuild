# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs user python-any-r1

DESCRIPTION="DNS server designed to serve blacklist zones"
HOMEPAGE="https://rbldnsd.io/"
SRC_URI="https://github.com/spamhaus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa sparc x86"
IUSE="ipv6 test zlib"
RESTRICT="!test? ( test )"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		${RDEPEND}
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pydns:2[${PYTHON_USEDEP}]')
	)"

PATCHES=(
	"${FILESDIR}/rbldnsd-0.997a-robust-ipv6-test-support.patch"
)

src_configure() {
	# The ./configure file is handwritten and doesn't support a `make
	# install` target, so there are no --prefix options. The econf
	# function appends those automatically, so we can't use it.
	./configure \
		$(use_enable ipv6) \
		$(use_enable zlib) \
		|| die "./configure failed"
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)"
}

src_test() {
	emake check \
		CC="$(tc-getCC)" \
		PYTHON="${PYTHON}"
}

src_install() {
	einstalldocs
	dosbin rbldnsd
	doman rbldnsd.8
	keepdir /var/db/rbldnsd
	newinitd "${FILESDIR}"/initd-0.997a rbldnsd
	newconfd "${FILESDIR}"/confd-0.997a rbldnsd
}

pkg_preinst() {
	enewgroup rbldns
	enewuser rbldns -1 -1 -1 rbldns
	fowners rbldns:rbldns /var/db/rbldnsd
}
