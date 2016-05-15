# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build

KEYWORDS="~amd64"
EGO_PN="github.com/astaxie/beego/..."
EGIT_COMMIT="fbb98fbe1fe5f6a4209772b44e2547714992340c"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/bradfitz/gomemcache/archive/fb1f79c6b65acda83063cbc69f6bba1522558bfc.tar.gz -> gomemcache-fb1f79c6b65acda83063cbc69f6bba1522558bfc.tar.gz
	https://github.com/garyburd/redigo/archive/836b6e58b3358112c8291565d01c35b8764070d7.tar.gz -> redigo-836b6e58b3358112c8291565d01c35b8764070d7.tar.gz
	https://github.com/beego/x2j/archive/a0352aadc5420072ebe692481a5d6913d77f8cf0.tar.gz -> x2j-a0352aadc5420072ebe692481a5d6913d77f8cf0.tar.gz
	https://github.com/beego/goyaml2/archive/5545475820ddd4db3f90a4900d44b65d077d702d.tar.gz -> goyaml2-5545475820ddd4db3f90a4900d44b65d077d702d.tar.gz
	https://github.com/wendal/errors/archive/f66c77a7882b399795a8987ebf87ef64a427417e.tar.gz -> errors-f66c77a7882b399795a8987ebf87ef64a427417e.tar.gz
	https://github.com/belogik/goes/archive/e54d722c3aff588e4c737fe11c07359019240824.tar.gz -> goes-e54d722c3aff588e4c737fe11c07359019240824.tar.gz
	https://github.com/couchbase/go-couchbase/archive/8cefc09994885b63d45e506861277e9743addd37.tar.gz -> go-couchbase-8cefc09994885b63d45e506861277e9743addd37.tar.gz
	https://github.com/couchbase/gomemcached/archive/eb29b2e515a50fded2382cbd79a369c0cb3abf41.tar.gz -> gomemcached-eb29b2e515a50fded2382cbd79a369c0cb3abf41.tar.gz
	https://github.com/siddontang/ledisdb/archive/713b22910a0b66d098c9e40ff19be258968e9a7d.tar.gz -> ledisdb-713b22910a0b66d098c9e40ff19be258968e9a7d.tar.gz
	https://github.com/BurntSushi/toml/archive/5c4df71dfe9ac89ef6287afc05e4c1b16ae65a1e.tar.gz -> toml-5c4df71dfe9ac89ef6287afc05e4c1b16ae65a1e.tar.gz
	https://github.com/boltdb/bolt/archive/2f846c3551b76d7710f159be840d66c3d064abbe.tar.gz -> bolt-2f846c3551b76d7710f159be840d66c3d064abbe.tar.gz
	https://github.com/edsrzf/mmap-go/archive/903d080718bd2877583fe1bd0a19c9cd3e2906ff.tar.gz -> mmap-go-903d080718bd2877583fe1bd0a19c9cd3e2906ff.tar.gz
	https://github.com/siddontang/go/archive/354e14e6c093c661abb29fd28403b3c19cff5514.tar.gz -> siddontang-go-354e14e6c093c661abb29fd28403b3c19cff5514.tar.gz
	https://github.com/siddontang/rdb/archive/fc89ed2e418d27e3ea76e708e54276d2b44ae9cf.tar.gz -> siddontang-rdb-fc89ed2e418d27e3ea76e708e54276d2b44ae9cf.tar.gz
	https://github.com/syndtr/goleveldb/archive/36d2ead1e477af53df038bdde5f7b5b3790c93dd.tar.gz -> goleveldb-36d2ead1e477af53df038bdde5f7b5b3790c93dd.tar.gz
	https://github.com/cupcake/rdb/archive/f5614b4eb12a23e0c65b51f7c22635ef1a16f725.tar.gz -> rdb-f5614b4eb12a23e0c65b51f7c22635ef1a16f725.tar.gz
	https://github.com/golang/snappy/archive/894fd4616c897c201d223c3c0c128e8c648c96a2.tar.gz -> golang-snappy-894fd4616c897c201d223c3c0c128e8c648c96a2.tar.gz
	https://github.com/go-sql-driver/mysql/archive/267b128680c46286b9ca13475c3cca5de8f79bd7.tar.gz -> go-mysql-267b128680c46286b9ca13475c3cca5de8f79bd7.tar.gz
	https://github.com/lib/pq/archive/f59175c2986495ff94109dee3835c504a96c3e81.tar.gz -> pq-f59175c2986495ff94109dee3835c504a96c3e81.tar.gz
	https://github.com/mattn/go-sqlite3/archive/c5aee9649735e8dadac55eb968ccebd9fa29a881.tar.gz -> go-sqlite3-1.1.0_p20160131.tar.gz"

DESCRIPTION="High-performance web framework for Go"
HOMEPAGE="https://${EGO_PN%/*}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""
RESTRICT="test"

get_archive_go_package() {
	local archive=${1} uri x
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	echo ${uri%/archive/*}
}

unpack_go_packages() {
	local go_package x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			mkdir -p "${S}/src/${go_package%/*}"
			for x in ${go_package##*/}-*; do
				[[ ${x} -ef ${S} ]] && continue
				mv "${x}" "${S}/src/${go_package}" || die
			done
		fi
	done
}

src_unpack() {
	unpack_go_packages
}

golang_install_pkgs() {
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto $(dirname "${EPREFIX}$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}{,.a}
	insinto $(dirname "${EPREFIX}$(get_golibdir)/src/${EGO_PN%/*}")
	doins -r "${S}"/src/${EGO_PN%/*}
}
