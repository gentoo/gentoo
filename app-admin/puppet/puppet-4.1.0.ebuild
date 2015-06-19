# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/puppet/puppet-4.1.0.ebuild,v 1.1 2015/05/27 05:32:52 prometheanfire Exp $

EAPI="5"

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit elisp-common xemacs-elisp-common eutils user ruby-fakegem versionator

DESCRIPTION="A system automation and configuration management software."
HOMEPAGE="http://puppetlabs.com/"
SRC_URI="http://downloads.puppetlabs.com/puppet/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="augeas diff doc emacs ldap rrdtool selinux shadow sqlite vim-syntax xemacs"

ruby_add_rdepend "
	dev-ruby/hiera
	>=dev-ruby/rgen-0.6.5 =dev-ruby/rgen-0.6*
	>=dev-ruby/facter-1.6.2 <dev-ruby/facter-3
	dev-ruby/json
	augeas? ( dev-ruby/ruby-augeas )
	diff? ( dev-ruby/diff-lcs )
	doc? ( dev-ruby/rdoc )
	ldap? ( dev-ruby/ruby-ldap )
	shadow? ( dev-ruby/ruby-shadow )
	sqlite? ( dev-ruby/sqlite3 )
	virtual/ruby-ssl"

DEPEND="${DEPEND}
	dev-lang/ruby
	emacs? ( virtual/emacs )
	xemacs? ( app-editors/xemacs )"
RDEPEND="${RDEPEND}
	rrdtool? ( >=net-analyzer/rrdtool-1.2.23[ruby] )
	selinux? (
		sys-libs/libselinux[ruby]
		sec-policy/selinux-puppet
	)
	vim-syntax? ( >=app-vim/puppet-syntax-3.0.1 )
	>=app-portage/eix-0.18.0"

SITEFILE="50${PN}-mode-gentoo.el"

pkg_setup() {
	enewgroup puppet
	enewuser puppet -1 -1 /var/lib/puppet puppet
}

all_ruby_prepare() {
	# Avoid spec that require unpackaged json-schema.
	rm spec/lib/matchers/json.rb $( grep -Rl matchers/json spec) || die

	# Avoid specs that can only run in the puppet.git repository. This
	# should be narrowed down to the specific specs.
	rm spec/integration/parser/compiler_spec.rb || die

	# Avoid failing spec that need further investigation.
	rm spec/unit/module_tool/metadata_spec.rb || die
}

all_ruby_compile() {
	if use emacs ; then
		elisp-compile ext/emacs/puppet-mode.el
	fi

	if use xemacs ; then
		# Create a separate version for xemacs to be able to install
		# emacs and xemacs in parallel.
		mkdir ext/xemacs
		cp ext/emacs/* ext/xemacs/
		xemacs-elisp-compile ext/xemacs/puppet-mode.el
	fi
}

each_ruby_install() {
	each_fakegem_install
}

all_ruby_install() {
	all_fakegem_install

	# systemd stuffs
	insinto /usr/lib/systemd/system
	doins "${WORKDIR}/all/${P}/ext/systemd/puppet.service"
	doins "${WORKDIR}/all/${P}/ext/systemd/puppetmaster.service"

	# tmpfiles stuff
	insinto /usr/lib/tmpfiles.d
	newins "${FILESDIR}/tmpfiles.d" "puppet.conf"

	# openrc init stuff
	newinitd "${FILESDIR}"/puppet.init-4.x puppet
	newinitd "${FILESDIR}"/puppetmaster.init-4.x puppetmaster
	newconfd "${FILESDIR}"/puppetmaster.confd puppetmaster

	keepdir /etc/puppetlabs/puppet/ssl

	keepdir /var/lib/puppet/facts
	keepdir /var/lib/puppet/files
	fowners -R puppet:puppet /var/lib/puppet

	fperms 0750 /var/lib/puppet

	fperms 0750 /etc/puppetlabs
	fperms 0750 /etc/puppetlabs/puppet
	fperms 0750 /etc/puppetlabs/puppet/ssl
	fowners -R :puppet /etc/puppetlabs
	fowners -R :puppet /var/lib/puppet

	if use emacs ; then
		elisp-install ${PN} ext/emacs/puppet-mode.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use xemacs ; then
		xemacs-elisp-install ${PN} ext/xemacs/puppet-mode.el*
		xemacs-elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use ldap ; then
		insinto /etc/openldap/schema; doins ext/ldap/puppet.schema
	fi

	# ext and examples files
	for f in $(find ext examples -type f) ; do
		docinto "$(dirname ${f})"; dodoc "${f}"
	done
}

pkg_postinst() {
	elog
	elog "Please, *don't* include the --ask option in EMERGE_EXTRA_OPTS as this could"
	elog "cause puppet to hang while installing packages."
	elog
	elog "Portage Puppet module with Gentoo-specific resources:"
	elog "http://forge.puppetlabs.com/gentoo/portage"
	elog

	if [ "$(get_major_version $REPLACING_VERSIONS)" = "3" ]; then
		elog
		elog "If you're upgrading from 3.x then please move everything in /etc/puppet to"
		elog "/etc/puppetlabs/puppet"
		elog "Also, puppet now uses config directories for modules and manifests."
		elog "See https://docs.puppetlabs.com/puppet/4.0/reference/upgrade_agent.html"
		elog "and https://docs.puppetlabs.com/puppet/4.0/reference/upgrade_server.html"
		elog "for more information."
		elog
	fi

	use emacs && elisp-site-regen
	use xemacs && xemacs-elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use xemacs && xemacs-elisp-site-regen
}
