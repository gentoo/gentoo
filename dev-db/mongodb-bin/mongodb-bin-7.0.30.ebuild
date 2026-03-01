# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils rpm systemd

DESCRIPTION="A high-performance, open source, schema-free document-oriented database (binary)"
HOMEPAGE="https://www.mongodb.com"

# prefer RPMS to avoid dealing with debianisms
SRC_URI="
	amd64? (
		https://repo.mongodb.org/yum/amazon/2023/mongodb-org/$(ver_cut 1-2)/x86_64/RPMS/mongodb-org-server-${PV}-1.amzn2023.x86_64.rpm
		https://repo.mongodb.org/yum/amazon/2023/mongodb-org/$(ver_cut 1-2)/x86_64/RPMS/mongodb-org-mongos-${PV}-1.amzn2023.x86_64.rpm
	)
	arm64? (
		https://repo.mongodb.org/yum/amazon/2023/mongodb-org/$(ver_cut 1-2)/aarch64/RPMS/mongodb-org-server-${PV}-1.amzn2023.aarch64.rpm
		https://repo.mongodb.org/yum/amazon/2023/mongodb-org/$(ver_cut 1-2)/aarch64/RPMS/mongodb-org-mongos-${PV}-1.amzn2023.aarch64.rpm
	)
"
S="${WORKDIR}"

LICENSE="Apache-2.0 SSPL-1"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

# Apparent unconditional hardware requirements.
# https://github.com/mongodb/mongo/blob/v8.0/src/mongo/db/fts/unicode/byte_vector.h#L35

# https://www.mongodb.com/docs/manual/administration/production-notes/#x86_64
# AVX required
AMD64_CPU_FLAGS="cpu_flags_x86_avx cpu_flags_x86_sse"
# https://www.mongodb.com/docs/manual/administration/production-notes/#arm64
# ARM8.2-A required
ARM64_CPU_FLAGS+=" cpu_flags_arm_neon cpu_flags_arm_neon-fp16"

IUSE="+mongosh +tools ${AMD64_CPU_FLAGS} ${ARM64_CPU_FLAGS}"
REQUIRED_USE="amd64? ( ${AMD64_CPU_FLAGS} ) arm64? ( ${ARM64_CPU_FLAGS} )"

RDEPEND="
	!dev-db/mongodb
	acct-group/mongodb
	acct-user/mongodb
	dev-libs/openssl
	net-misc/curl
	sys-devel/gcc
"
PDEPEND="
	mongosh? ( app-admin/mongosh-bin )
	tools? ( >=app-admin/mongo-tools-100 )
"

QA_PREBUILT="*"

src_prepare() {
	default

	# uncompress files
	gzip -d usr/share/man/man*/*.gz || die
}

src_install() {
	dobin usr/bin/{mongod,mongos}

	doman usr/share/man/man*/mongo*.*
	dodoc usr/share/doc/mongodb-org-server/*

	newinitd "${FILESDIR}/mongodb.initd-r3" mongodb
	newconfd "${FILESDIR}/mongodb.confd-r3" mongodb
	newinitd "${FILESDIR}/mongos.initd-r3" mongos
	newconfd "${FILESDIR}/mongos.confd-r3" mongos

	insinto /etc
	newins "${FILESDIR}/mongodb.conf-r3" mongodb.conf
	newins "${FILESDIR}/mongos.conf-r2" mongos.conf

	systemd_newunit "${FILESDIR}/mongodb.service-r1" "mongodb.service"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/mongodb.logrotate" mongodb

	# see bug #526114
	pax-mark emr "${ED}"/usr/bin/{mongod,mongos}

	diropts -m0750 -o mongodb -g mongodb
	keepdir /var/log/mongodb
}

pkg_postinst() {
	ewarn "Make sure to read the release notes and follow the upgrade process:"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(ver_cut 1-2)/"
	ewarn "  https://docs.mongodb.com/manual/release-notes/$(ver_cut 1-2)/#upgrade-procedures"
}
