# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/facter/facter-2.4.1-r1.ebuild,v 1.1 2015/02/17 06:45:10 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINWRAP="facter"

inherit ruby-fakegem

DESCRIPTION="A cross-platform Ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+dmi +pciutils +virt"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

CDEPEND="
	app-emulation/virt-what
	sys-apps/net-tools
	sys-apps/lsb-release
	dmi? ( sys-apps/dmidecode )
	pciutils? ( sys-apps/pciutils )"

RDEPEND+=" ${CDEPEND}"
DEPEND+=" test? ( ${CDEPEND} )"

ruby_add_bdepend "test? ( dev-ruby/mocha:1.0 )"

all_ruby_prepare() {
	# Provide explicit path since /sbin is not in the default PATH on
	# Gentoo.
	sed -i -e 's:arp -an:/sbin/arp -an:' lib/facter/util/ec2.rb spec/unit/util/ec2_spec.rb || die

	# Ensure the correct version of mocha is used without using bundler.
	sed -i -e '1igem "mocha", "~>1.0"' spec/spec_helper.rb || die

	# Avoid because tests try to access outside stuff, e.g. /sys/block
	sed -i -e '/should load facts on the facter search path only once/,/^  end/ s:^:#:' spec/unit/util/loader_spec.rb || die

	# Allow specs to work with newer rspec 2.x versions.
	sed -i -e '1irequire "rspec-expectations"' spec/puppetlabs_spec/matchers.rb || die

	# Avoid specs specific to macosx requiring cfpropertylist which is
	# not available anymore.
	rm spec/unit/util/macosx_spec.rb || die
	sed -i -e '/macosx/ s:^:#:' \
		-e '/on Darwin/,/^  end/ s:^:#:' spec/unit/virtual_spec.rb || die
	sed -i -e '/Facter::Processors::Darwin/,/^end/ s:^:#:' spec/unit/processors/os_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install

	# Create the directory for custom facts.
	keepdir /etc/facter/facts.d
}
