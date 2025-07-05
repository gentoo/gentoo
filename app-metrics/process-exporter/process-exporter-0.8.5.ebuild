# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

# update on every bump
REVISION=626431b9a759d425bbb78eb15153f892970aadee
DESCRIPTION="Process exporter for prometheus"
HOMEPAGE="https://github.com/ncabatoff/process-exporter"
SRC_URI="https://github.com/ncabatoff/process-exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	#See bug 924632
	case $ARCH in
		x86|arm)
			ewarn "Force CGO_ENABLED=1 for $ARCH, see bug #924632"
			sed -r -i \
				-e 's/(CGO_ENABLED=)0/\11/g' \
				Makefile \
				|| ewarn "Can not force CGO_ENABLED=1"
		;;
	esac
	eapply_user
}

src_compile() {
	emake \
		BRANCH=HEAD \
		REVISION=${REVISION} \
		TAG_VERSION=v${PV} \
		build
}

src_install() {
	dobin ${PN}
	dodoc *.md
	insinto /etc/${PN}
	doins packaging/conf/all.yaml
	systemd_dounit packaging/${PN}.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/log/${PN}
}
