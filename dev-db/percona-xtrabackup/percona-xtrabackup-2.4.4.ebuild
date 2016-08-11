# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Hot backup utility for MySQL based servers"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-xtrabackup"
SRC_URI="https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-${PV}/source/tarball/${P}.tar.gz
	!system-boost? ( http://jenkins.percona.com/downloads/boost/boost_1_59_0.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="system-boost"

DEPEND="system-boost? ( =dev-libs/boost-1.59.0 )
		app-editors/vim-core
		dev-libs/libaio
		dev-libs/libev
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
		dev-python/sphinx
		net-misc/curl
		sys-libs/zlib"
RDEPEND="${DEPEND}
		!dev-db/xtrabackup-bin
		dev-perl/DBD-mysql"

src_configure() {
	local my_args

	if ! use system-boost; then
		my_args="-DDOWNLOAD_BOOST=0 -DWITH_BOOST=${WORKDIR}"
	fi

	cmake -DBUILD_CONFIG=xtrabackup_release $my_args || die
}

src_compile() {
	emake
}

src_install() {
	local p="storage/innobase/xtrabackup"

	for tool in xbcloud xbcrypt xbstream xtrabackup; do
		dobin ${p}/src/${tool}
	done

	dosym xtrabackup /usr/bin/innobackupex

	doman ${p}/doc/source/build/man/*
}
