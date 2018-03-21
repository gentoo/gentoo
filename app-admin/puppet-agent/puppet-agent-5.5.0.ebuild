# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils systemd unpacker user

DESCRIPTION="general puppet client utils along with mcollective hiera and facter"
HOMEPAGE="https://puppetlabs.com/"
SRC_BASE="http://apt.puppetlabs.com/pool/stretch/puppet5/${PN:0:1}/${PN}/${PN}_${PV}-1stretch"
SRC_URI="
	amd64? ( ${SRC_BASE}_amd64.deb )
	x86?   ( ${SRC_BASE}_i386.deb )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="puppetdb selinux"
RESTRICT="strip"

CDEPEND="!app-admin/augeas
	!app-admin/mcollective
	!app-admin/puppet
	!dev-ruby/hiera
	!dev-ruby/facter
	!app-emulation/virt-what"

DEPEND="
	${CDEPEND}"
RDEPEND="${CDEPEND}
	app-portage/eix
	sys-apps/dmidecode
	sys-libs/glibc
	sys-libs/readline:0/7
	sys-libs/ncurses:0[tinfo]
	selinux? (
		sys-libs/libselinux[ruby]
		sec-policy/selinux-puppet
	)
	puppetdb? ( >=dev-ruby/puppetdb-termini-5.0.1 )"

S=${WORKDIR}

pkg_setup() {
	enewgroup puppet
	enewuser puppet -1 -1 /var/run/puppet puppet
}

src_install() {
	# conf.d
	doconfd etc/default/puppet
	doconfd etc/default/mcollective
	doconfd etc/default/pxp-agent
	# logrotate.d
	insinto /etc/logrotate.d
	doins etc/logrotate.d/mcollective
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
	newinitd "${FILESDIR}/mcollective.initd" mcollective
	systemd_dounit lib/systemd/system/puppet.service
	systemd_dounit lib/systemd/system/mcollective.service
	systemd_dounit lib/systemd/system/pxp-agent.service
	systemd_newtmpfilesd "${FILESDIR}/puppet-agent.conf.tmpfilesd" puppet-agent.conf
	# symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/puppet/bin/"
	chmod 0755 "${D}//opt/puppetlabs/puppet/lib/virt-what/virt-what-cpuid-helper"
	dosym ../../opt/puppetlabs/bin/facter /usr/bin/facter
	dosym ../../opt/puppetlabs/bin/hiera /usr/bin/hiera
	dosym ../../opt/puppetlabs/bin/mco /usr/bin/mco
	dosym ../../opt/puppetlabs/bin/puppet /usr/bin/puppet
	dosym ../../opt/puppetlabs/puppet/bin/mcollectived /usr/sbin/mcollectived
	dosym ../../opt/puppetlabs/puppet/bin/virt-what /usr/bin/virt-what
	dosym ../../opt/puppetlabs/puppet/bin/augparse /usr/bin/augparse
	dosym ../../opt/puppetlabs/puppet/bin/augtool /usr/bin/augtool
}
