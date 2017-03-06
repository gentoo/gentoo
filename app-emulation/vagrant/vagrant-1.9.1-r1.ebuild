# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="vagrant.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL="keys plugins templates version.txt"
RUBY_FAKEGEM_TASK_DOC=""

inherit bash-completion-r1 ruby-fakegem eutils

DESCRIPTION="A tool for building and distributing development environments"
HOMEPAGE="http://vagrantup.com/"
SRC_URI="https://github.com/mitchellh/vagrant/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+virtualbox"

RDEPEND="${RDEPEND}
	app-arch/libarchive
	net-misc/curl
	virtualbox? ( || ( app-emulation/virtualbox app-emulation/virtualbox-bin ) )"

ruby_add_rdepend "
	>=dev-ruby/childprocess-0.5.0
	>=dev-ruby/erubis-2.7.0
	>=dev-ruby/i18n-0.6.0:* <dev-ruby/i18n-0.8.0:*
	>=dev-ruby/listen-3.1.5
	>=dev-ruby/hashicorp-checkpoint-0.1.1
	>=dev-ruby/log4r-1.1.9 <dev-ruby/log4r-1.1.11
	>=dev-ruby/net-ssh-3.0.1:*
	>=dev-ruby/net-sftp-2.1
	>=dev-ruby/net-scp-1.1.0
	|| ( >=dev-ruby/rest-client-1.6.0:0 dev-ruby/rest-client:2 )
	>=dev-ruby/nokogiri-1.6.7.1
	>=dev-ruby/mime-types-2.6.2:* <dev-ruby/mime-types-3:*
"

ruby_add_bdepend "
	>=dev-ruby/rake-11.3.0
"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die

	# loosen dependencies
	sed -e '/hashicorp-checkpoint\|listen\|net-ssh\|net-scp\|rake\|childprocess/s/~>/>=/' \
		-e '/ruby_dep/s/<=/>=/' \
		-e '/nokogiri/s/=/>=/' \
		-i ${PN}.gemspec || die

	# remove windows-specific gems
	sed -e '/wdm\|winrm/d' \
		-i ${PN}.gemspec || die

	# remove bsd-specific gems
	sed -e '/rb-kqueue/d' \
		-i ${PN}.gemspec || die

	# disable embedded CA certs and use system ones
	epatch "${FILESDIR}"/${PN}-1.8.1-disable-embedded-cacert.patch

	# fix rvm issue (bug #474476)
	epatch "${FILESDIR}"/${PN}-1.8.1-rvm.patch
}

all_ruby_install() {
	newbashcomp contrib/bash/completion.sh ${PN}
	all_fakegem_install

	# provide executable similar to upstream:
	# https://github.com/mitchellh/vagrant-installers/blob/master/substrate/modules/vagrant_installer/templates/vagrant.erb
	newbin "${FILESDIR}/${P}" "${PN}"

	# directory for plugins.json
	dodir /var/lib/vagrant
}
