# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils unpacker

DESCRIPTION="Puppet SDK - develop and test puppet modules"
HOMEPAGE="https://puppetlabs.com/"
SRC_BASE="http://apt.puppetlabs.com/pool/stretch/puppet/${PN:0:1}/${PN}/${PN}_${PV}-1stretch"
SRC_URI="
	amd64? ( ${SRC_BASE}_amd64.deb )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="strip"

S=${WORKDIR}

QA_PREBUILT="
	/opt/puppetlabs/pdk
	/opt/puppetlabs/pdk/lib/engines/*
	/opt/puppetlabs/pdk/lib/*
	/opt/puppetlabs/pdk/bin/*"

src_install() {
	# Drop the opt folder into place
	insinto /opt
	doins -r opt/*

	# Add symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/git/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/ruby/2.1.9/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/ruby/2.4.4/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/ruby/2.5.1/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/puppet/ruby/2.1.0/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/puppet/ruby/2.4.0/bin/"
	chmod 0755 -R "${D}/opt/puppetlabs/pdk/private/puppet/ruby/2.5.0/bin/"

	# remove rwx a.out stuff
	rm "${D}"/opt/puppetlabs/pdk/private/ruby/2.4.4/lib/ruby/gems/2.4.0/gems/ffi-1.9.25/ext/ffi_c/libffi-x86_64-linux/a.out
	rm "${D}"/opt/puppetlabs/pdk/share/cache/ruby/2.1.0/gems/ffi-1.9.25/ext/ffi_c/libffi-x86_64-linux/a.out
	rm "${D}"/opt/puppetlabs/pdk/share/cache/ruby/2.5.0/gems/ffi-1.9.25/ext/ffi_c/libffi-x86_64-linux/a.out

	dosym ../../opt/puppetlabs/pdk/bin/pdk /usr/bin/pdk
}
