# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DORMANDO
DIST_VERSION=${PV%0.0}
inherit user perl-module

DESCRIPTION="Server for the MogileFS distributed file system"
HOMEPAGE="http://www.danga.com/mogilefs/ ${HOMEPAGE}"

IUSE="mysql +sqlite test postgres"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( sqlite ) || ( mysql sqlite postgres )"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"

# Upstream site recommends this,
# but it breaks Perlbal
# dev-perl/Perlbal-XS-HTTPHeaders
RDEPEND="dev-perl/Net-Netmask
		>=dev-perl/Danga-Socket-1.610.0
		>=dev-perl/Sys-Syscall-0.220.0
		>=dev-perl/Perlbal-1.790
		>=dev-perl/IO-AIO-4
		dev-perl/libwww-perl
		>=dev-perl/MogileFS-Client-1.170.0
		>=dev-perl/MogileFS-Utils-2.280.0
		dev-perl/Cache-Memcached
		dev-perl/DBI
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg )
		sqlite? ( dev-perl/DBD-SQLite )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.720.0-gentoo-init-conf.patch"
)
DIST_TEST="never verbose"

MOGILE_USER="mogile"

pkg_setup() {
	# Warning! It is important that the uid is constant over Gentoo machines
	# As mogilefs may be used with non-local block devices that move!
	enewuser ${MOGILE_USER} 460 -1 -1
}

src_install() {
	perl-module_src_install || die "perl-module_src_install failed"
	cd "${S}"

	newconfd "${S}"/gentoo/conf.d/mogilefsd mogilefsd
	newinitd "${S}"/gentoo/init.d/mogilefsd mogilefsd

	newconfd "${S}"/gentoo/conf.d/mogstored mogstored
	newinitd "${S}"/gentoo/init.d/mogstored mogstored

	newinitd "${S}"/gentoo/init.d/mogautomount mogautomount

	diropts -m 700 -o ${MOGILE_USER}
	keepdir /var/mogdata

	diropts -m 755 -o root
	dodir /etc/mogilefs

	insinto /etc/mogilefs
	insopts -m 600 -o root -g ${MOGILE_USER}
	newins "${S}"/gentoo/conf/mogilefsd.conf mogilefsd.conf
	newins "${S}"/gentoo/conf/mogstored.conf mogstored.conf
}

pkg_postinst() {
	chmod 640 "${ROOT}"/etc/mogilefs/{mogilefsd,mogstored}.conf
	chown root:${MOGILE_USER} "${ROOT}"/etc/mogilefs/{mogilefsd,mogstored}.conf
}

src_test() {
	# these need to be in the env and the makeopts
	export MOGTEST_DBUSER=mogile MOGTEST_DBNAME=tmp_mogiletest MOGTEST_DBTYPE=SQLite TMPDIR="${T}/mogile"
	#perl-module_src_test
	make -j1 test TEST_VERBOSE=1 MOGTEST_DBUSER=${MOGTEST_DBUSER} MOGTEST_DBNAME=${MOGTEST_DBNAME} MOGTEST_DBTYPE=${MOGTEST_DBTYPE} TMPDIR="${TMPDIR}"
}
