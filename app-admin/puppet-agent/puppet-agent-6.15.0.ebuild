# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils systemd unpacker

DESCRIPTION="general puppet client utils along with hiera and facter"
HOMEPAGE="https://puppetlabs.com/"
SRC_BASE="http://apt.puppetlabs.com/pool/stretch/puppet/${PN:0:1}/${PN}/${PN}_${PV}-1stretch"
SRC_URI="
	amd64? ( ${SRC_BASE}_amd64.deb )
	x86?   ( ${SRC_BASE}_i386.deb )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="puppetdb selinux"
RESTRICT="strip"

CDEPEND="!app-admin/puppet
	!dev-ruby/hiera
	!dev-ruby/facter
	!app-emulation/virt-what
	acct-user/puppet
	acct-group/puppet"

DEPEND="
	${CDEPEND}
	app-admin/augeas"
RDEPEND="${CDEPEND}
	app-portage/eix
	sys-apps/dmidecode
	sys-libs/libselinux
	sys-libs/glibc
	sys-libs/readline:0/7
	sys-libs/ncurses:0[tinfo]
	selinux? (
		sys-libs/libselinux[ruby]
		sec-policy/selinux-puppet
	)
	puppetdb? ( >=dev-ruby/puppetdb-termini-5.0.1 )"

S=${WORKDIR}

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
	dodir var/log/puppetlabs/puppet/
	fperms 0750 var/log/puppetlabs/puppet/
	# the rest
	insinto /opt
	dodir opt/puppetlabs/puppet/cache
	doins -r opt/*
	fperms 0750 /opt/puppetlabs/puppet/cache
	# init
	newinitd "${FILESDIR}/puppet.initd" puppet
	systemd_dounit lib/systemd/system/puppet.service
	systemd_dounit lib/systemd/system/pxp-agent.service
	systemd_newtmpfilesd "${FILESDIR}/puppet-agent.conf.tmpfilesd" puppet-agent.conf
	# symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/puppet/bin/"
	chmod 0755 "${D}//opt/puppetlabs/puppet/lib/virt-what/virt-what-cpuid-helper"
	dosym ../../opt/puppetlabs/bin/facter /usr/bin/facter
	dosym ../../opt/puppetlabs/bin/hiera /usr/bin/hiera
	dosym ../../opt/puppetlabs/bin/puppet /usr/bin/puppet
	dosym ../../opt/puppetlabs/puppet/bin/virt-what /usr/bin/virt-what
}
