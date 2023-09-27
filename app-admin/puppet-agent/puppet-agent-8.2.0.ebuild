# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd unpacker tmpfiles

DESCRIPTION="general puppet client utils along with hiera and facter"
HOMEPAGE="https://puppetlabs.com/"
SRC_URI="amd64? ( http://apt.puppetlabs.com/pool/focal/puppet8/${PN:0:1}/${PN}/${PN}_${PV}-1focal_amd64.deb )
arm64? ( http://apt.puppetlabs.com/pool/focal/puppet8/${PN:0:1}/${PN}/${PN}_${PV}-1focal_arm64.deb )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="puppetdb selinux"
RESTRICT="strip"

# virtual/libcrypt:= is in here despite being a pre-built package
# to ensure that the has_version logic for the symlink doesn't become stale
CDEPEND="!app-admin/puppet
	!dev-ruby/hiera
	!dev-ruby/facter
	app-emulation/virt-what
	acct-user/puppet
	acct-group/puppet
	virtual/libcrypt:="

DEPEND="
	${CDEPEND}
	app-admin/augeas"
RDEPEND="${CDEPEND}
	app-portage/eix
	sys-apps/dmidecode
	sys-libs/libselinux
	sys-libs/glibc
	sys-libs/readline:0/8
	sys-libs/libxcrypt[compat]
	sys-libs/ncurses:0[tinfo]
	selinux? (
		sys-libs/libselinux[ruby]
		sec-policy/selinux-puppet
	)
	puppetdb? ( >=dev-ruby/puppetdb-termini-5.0.1 )"

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	# conf.d
	doconfd etc/default/puppet
	doconfd etc/default/pxp-agent
	# logrotate.d
	insinto /etc/logrotate.d
	doins etc/logrotate.d/pxp-agent
	# puppet itself
	insinto /etc/puppetlabs
	doins -r etc/puppetlabs/*
	# logdir for systemd
	keepdir var/log/puppetlabs/puppet/
	chmod 0750 var/log/puppetlabs/puppet/
	# the rest
	insinto /opt
	dodir opt/puppetlabs/puppet/cache
	doins -r opt/*
	fperms 0750 /opt/puppetlabs/puppet/cache
	# init
	newinitd "${FILESDIR}/puppet.initd2" puppet
	systemd_dounit lib/systemd/system/puppet.service
	systemd_dounit lib/systemd/system/pxp-agent.service
	newtmpfiles usr/lib/tmpfiles.d/puppet-agent.conf puppet-agent.conf
	# symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/puppet/bin/"
	dosym ../../opt/puppetlabs/bin/facter /usr/bin/facter
	dosym ../../opt/puppetlabs/bin/hiera /usr/bin/hiera
	dosym ../../opt/puppetlabs/bin/puppet /usr/bin/puppet

	# Handling of the path to the crypt library during the ongoing migration
	# from glibc[crypt] to libxcrypt
	# https://www.gentoo.org/support/news-items/2021-07-23-libxcrypt-migration.html
	if has_version "sys-libs/glibc[crypt]"; then
		local crypt_target='../../../../usr/lib64/xcrypt/libcrypt.so.1'
	else
		local crypt_target='../../../../usr/lib/libcrypt.so.1'
	fi
	dosym $crypt_target /opt/puppetlabs/puppet/lib/libcrypt.so.1
}

pkg_postinst() {
	tmpfiles_process puppet-agent.conf
}
