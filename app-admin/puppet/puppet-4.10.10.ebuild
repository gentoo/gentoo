# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

USE_RUBY="ruby22 ruby23 ruby24"

#RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="locales"

inherit xemacs-elisp-common eutils user ruby-fakegem versionator

DESCRIPTION="A system automation and configuration management software."
HOMEPAGE="http://puppetlabs.com/"
SRC_URI="http://downloads.puppetlabs.com/puppet/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="augeas diff doc emacs experimental ldap rrdtool selinux shadow sqlite vim-syntax xemacs"
RESTRICT="test"

ruby_add_rdepend "
	>=dev-ruby/gettext-setup-0.10:0
	>=dev-ruby/hiera-2.0
	>=dev-ruby/locale-2.1
	>=dev-ruby/rgen-0.6.5
	dev-ruby/json:=
	>=dev-ruby/facter-3.0.0
	augeas? ( dev-ruby/ruby-augeas )
	diff? ( dev-ruby/diff-lcs )
	doc? ( dev-ruby/rdoc )
	ldap? ( dev-ruby/ruby-ldap )
	shadow? ( dev-ruby/ruby-shadow )
	sqlite? ( dev-ruby/sqlite3 )
	virtual/ruby-ssl"

# ruby_add_bdepend "
# 	test? (
# 		dev-ruby/mocha:0.14
# 		=dev-ruby/rack-1*
# 		dev-ruby/rspec-its
# 		dev-ruby/rspec-collection_matchers
# 		>=dev-ruby/vcr-2.9:2
# 		>=dev-ruby/webmock-1.24:0
# 	)"

DEPEND+=" ${DEPEND}
	xemacs? ( app-editors/xemacs )"
RDEPEND+=" ${RDEPEND}
	rrdtool? ( >=net-analyzer/rrdtool-1.2.23[ruby] )
	selinux? (
		sys-libs/libselinux[ruby]
		sec-policy/selinux-puppet
	)
	vim-syntax? ( >=app-vim/puppet-syntax-3.0.1 )
	>=app-portage/eix-0.18.0"
PDEPEND="emacs? ( >=app-emacs/puppet-mode-0.3-r1 )"

SITEFILE="50${PN}-mode-gentoo.el"

pkg_setup() {
	enewgroup puppet
	enewuser puppet -1 -1 /var/lib/puppet puppet
}

all_ruby_prepare() {
	# Avoid spec that require unpackaged json-schema.
	rm spec/lib/matchers/json.rb $( grep -Rl matchers/json spec) || die

	# can't be run within portage.
	epatch "${FILESDIR}/puppet-fix-tests-4.7.0.patch"

	# fix systemd path
	epatch "${FILESDIR}/puppet-systemd.patch"

	if use experimental; then
		epatch "${FILESDIR}/43e2c935252b995134ce353e5e6312cf77aea480.patch"
	fi

	# fix compatibility with ruby 2.3.6/2.4.3 webrick
	epatch "${FILESDIR}/puppet-4-webrick-ruby.patch"

	# Use working version of mocha
	sed -i -e '1igem "mocha", "~>0.14.0"; gem "rack", "~>1.0"' spec/spec_helper.rb || die

	# Avoid specs that can only run in the puppet.git repository. This
	# should be narrowed down to the specific specs.
	rm spec/integration/parser/compiler_spec.rb || die

	# Avoid failing specs that need further investigation.
	sed -i -e '/should resolve external facts/,/^    end/ s:^:#:' \
		spec/integration/indirector/facts/facter_spec.rb || die
	sed -i -e "/describe 'cfacter'/,/^  end/ s:^:#:" spec/unit/defaults_spec.rb || die
	rm -f spec/unit/indirector/ldap_spec.rb \
		spec/unit/parser/functions/create_resources_spec.rb || die

	# Avoid specs that rely on tools from other OSs
	rm -f spec/unit/provider/package/{dnf,tdnf,yum}_spec.rb \
	   spec/unit/provider/user/directoryservice_spec.rb || die

	# Avoid specs that depend on hiera-eyaml to avoid circular
	# dependencies
	rm -f spec/unit/functions/lookup_spec.rb || die

	# Avoid specs that fail due to an unpackaged file
	sed -i -e '/when loading pp resource types using auto loading/,/^  end/ s:^:#:' spec/unit/pops/loaders/loaders_spec.rb || die
}

all_ruby_compile() {
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
#	dosym "/usr/$(get_libdir)/ruby/gems/$(ruby_get_version)/gems/${P}" "/usr/$(get_libdir)/ruby/gems/$(ruby_get_version)/gems/${PN}"
}

all_ruby_install() {
	all_fakegem_install

	# systemd stuffs
	insinto /usr/lib/systemd/system
	doins "${WORKDIR}/all/${P}/ext/systemd/puppet.service"

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

	local v
	for v in ${REPLACING_VERSIONS}; do
		if [ "$(get_major_version $v)" = "3" ]; then
			elog
			elog "If you're upgrading from 3.x then please move everything in /etc/puppet to"
			elog "/etc/puppetlabs/puppet"
			elog "Also, puppet now uses config directories for modules and manifests."
			elog "See https://docs.puppetlabs.com/puppet/4.0/reference/upgrade_agent.html"
			elog "and https://docs.puppetlabs.com/puppet/4.0/reference/upgrade_server.html"
			elog "for more information."
			elog
		fi
	done

	use xemacs && xemacs-elisp-site-regen
}

pkg_postrm() {
	use xemacs && xemacs-elisp-site-regen
}
