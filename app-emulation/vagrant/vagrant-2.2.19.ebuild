# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="vagrant.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL="keys plugins templates version.txt"
RUBY_FAKEGEM_TASK_DOC=""

inherit bash-completion-r1 optfeature ruby-fakegem

DESCRIPTION="A tool for building and distributing development environments"
HOMEPAGE="https://vagrantup.com/"
SRC_URI="https://github.com/hashicorp/vagrant/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	${RDEPEND}
	app-arch/libarchive
	net-misc/curl
"

ruby_add_rdepend "
	>=dev-ruby/bcrypt_pbkdf-1.0.0
	>=dev-ruby/childprocess-4.0.0
	>=dev-ruby/ed25519-1.2.4
	dev-ruby/erubi
	>=dev-ruby/hashicorp-checkpoint-0.1.5
	>=dev-ruby/i18n-1.8:1
	>=dev-ruby/listen-3.1
	<dev-ruby/log4r-1.1.11
	>=dev-ruby/mime-types-3.3:*
	>=dev-ruby/rubyzip-2.0
	>=dev-ruby/net-scp-3.0.0
	>=dev-ruby/net-sftp-3.0
	>=dev-ruby/net-ssh-6.1.0
	dev-ruby/rest-client:2
	>=dev-ruby/vagrant_cloud-3.0.5
	>=dev-ruby/rexml-3.2.5
"

ruby_add_bdepend "
	>=dev-ruby/rake-12.3.3
	test? (
		dev-ruby/rspec
		dev-ruby/rspec-its
		dev-ruby/webmock
	)
"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die
	rm tasks/bundler.rake || die

	sed -e ':rake\|rspec\|webmock: s:~>:>=:' \
		-e ':bcrypt_pbkdf\|hashicorp-checkpoint\|i18n\|listen\|net-ssh\|net-scp\|net-sftp\|childprocess: s:~>:>=:' \
		-e '/fake_ftp/ s:^#*:#:' \
		-e '/wdm/ s:^#*:#:' \
		-e '/winrm/ s:^#*:#:' \
		-e '/rb-kqueue/ s:^#*:#:' \
		-e '/ruby_dep/ s:^#*:#:' \
		-i ${PN}.gemspec || die

	sed -e "s/@VAGRANT_VERSION@/${PV}/g" "${FILESDIR}/${PN}.in" > "${PN}" || die
}

all_ruby_install() {
	all_fakegem_install

	newbashcomp contrib/bash/completion.sh ${PN}

	# provide executable similar to upstream:
	# https://github.com/hashicorp/vagrant-installers/blob/master/substrate/modules/vagrant_installer/templates/vagrant.erb
	dobin "${PN}"

	# directory for plugins.json
	keepdir /var/lib/vagrant

	insinto /usr/share/vim/vimfiles/syntax/
	doins contrib/vim/vagrantfile.vim

	optfeature_header "Optional emulation/container backends:"
	optfeature "VirtualBox support" app-emulation/virtualbox
	optfeature "Docker support" app-containers/docker
}
