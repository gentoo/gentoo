# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/metasploit/metasploit-9999.ebuild,v 1.35 2015/03/31 19:51:48 ulm Exp $

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/rapid7/metasploit-framework.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}"/all
	inherit git-r3
	KEYWORDS=""
else
	#https://github.com/rapid7/metasploit-framework/wiki/Downloads-by-Version
	SRC_URI="http://downloads.metasploit.com/data/releases/archive/framework-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}"/msf3
fi

#ruby20 doesn't have wide enough support in gentoo yet (but is semi-supported upstream)
USE_RUBY="ruby19"
inherit eutils ruby-ng

DESCRIPTION="Advanced open-source framework for developing, testing, and using vulnerability exploit code"
HOMEPAGE="http://www.metasploit.org/"
SLOT="9999"
LICENSE="BSD"
IUSE="development +java lorcon oracle +pcap test"

#multiple known bugs with tests reported upstream and ignored
#http://dev.metasploit.com/redmine/issues/8418 - worked around (fix user creation when possible)
RESTRICT="test"

RUBY_COMMON_DEPEND="virtual/ruby-ssl
	dev-ruby/activesupport:3.2
	dev-ruby/activerecord:3.2
	dev-ruby/bcrypt-ruby
	dev-ruby/builder:3
	dev-ruby/bundler
	dev-ruby/json
	dev-ruby/kissfft
	=dev-ruby/metasploit_data_models-0.17.0
	=dev-ruby/meterpreter_bins-0.0.6
	dev-ruby/msgpack
	dev-ruby/nokogiri
	=dev-ruby/rkelly-remix-0.0.6
	dev-ruby/sqlite3
	>=dev-ruby/pg-0.11
	=dev-ruby/packetfu-1.1.9
	dev-ruby/rb-readline
	dev-ruby/robots
	java? ( dev-ruby/rjb )
	lorcon? ( net-wireless/lorcon[ruby] )
	oracle? ( dev-ruby/ruby-oci8 )
	pcap? ( dev-ruby/pcaprub
		dev-ruby/network_interface )
	development? ( dev-ruby/fivemat
			dev-ruby/redcarpet
			dev-ruby/yard
			>=dev-ruby/rake-10.0.0
			>=dev-ruby/factory_girl-4.1.0 )"
ruby_add_bdepend "${RUBY_COMMON_DEPEND}
		test? ( >=dev-ruby/factory_girl-4.1.0
			dev-ruby/fivemat
			dev-ruby/database_cleaner
			>=dev-ruby/rspec-2.12
			dev-ruby/shoulda-matchers
			dev-ruby/timecop
			>=dev-ruby/rake-10.0.0 )"
ruby_add_rdepend "${RUBY_COMMON_DEPEND}"

COMMON_DEPEND="dev-db/postgresql[server]
	>=app-crypt/johntheripper-1.7.9-r1[-minimal]
	net-analyzer/nmap"
DEPEND+=" ${COMMON_DEPEND}"
RDEPEND+=" ${COMMON_DEPEND}
	>=app-eselect/eselect-metasploit-0.13"

RESTRICT="strip"

QA_PREBUILT="
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_x86_linux.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_armle_linux.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_x86_solaris.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_x64_linux.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_x86_bsd.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_mipsbe_linux.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/templates/template_mipsle_linux.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/meterpreter/msflinker_linux_x86.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/meterpreter/ext_server_sniffer.lso
	usr/$(get_libdir)/${PN}${SLOT}/data/meterpreter/ext_server_networkpug.lso
	usr/$(get_libdir)/${PN}${SLOT}/data/meterpreter/ext_server_stdapi.lso
	usr/$(get_libdir)/${PN}${SLOT}/data/exploits/CVE-2013-2171.bin
	usr/$(get_libdir)/${PN}${SLOT}/data/android/libs/x86/libndkstager.so
	usr/$(get_libdir)/${PN}${SLOT}/data/android/libs/mips/libndkstager.so
	usr/$(get_libdir)/${PN}${SLOT}/data/android/libs/armeabi/libndkstager.so
	"

pkg_setup() {
	if use test; then
		su postgres -c "dropdb msf_test_database" #this is intentionally allowed to fail
		su postgres -c "createuser msf_test_user -d -S -R"
		if [ $? -ne 0 ]; then
			su postgres -c "dropuser msf_test_user" || die
			su postgres -c "createuser msf_test_user -d -S -R" || die
		fi
		su postgres -c "createdb --owner=msf_test_user msf_test_database" || die
	fi
	ruby-ng_pkg_setup
}

all_ruby_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
	else
		default_src_unpack
		mv "${WORKDIR}"/all/msf3/* "${WORKDIR}"/all
		rm -r msf3
	fi
}

all_ruby_prepare() {
	# add psexec patch from pull request 2657 to allow custom exe templates from any files, bypassing most AVs
	#epatch "${FILESDIR}/agix_psexec_pull-2657.patch"
	epatch_user

	#unbundle johntheripper, at least it now defaults to running the system version
	rm -r data/john/run.*
	rm -r data/john/src.tar.bz2
	#remove random "cpuinfo" binaries which a only needed to detect which bundled john to run
	rm -r data/cpuinfo

	#remove random oudated collected garbage
	rm -r external

	#remove unneeded ruby bundler versioning files
	#Gemfile.lock contains the versions tested by the msf team but not the hard requirements
	#we regen this file in each_ruby_prepare
	rm Gemfile.lock
	#The Gemfile contains real known deps
	#add our dep on upstream rb-readline instead of bundled one
	sed -i "/gem 'packetfu'/a #use upstream readline instead of bundled\ngem 'rb-readline'" Gemfile || die
	sed -i "/gem 'fivemat'/s/, '1.2.1'//" Gemfile || die
	#remove the bundled readline
	#https://github.com/rapid7/metasploit-framework/pull/3105
	#this PR was closed due to numerous changes to their local fork, almost entirely for non-linux
	rm lib/rbreadline.rb
	#now we edit the Gemfile based on use flags
	#even if we pass --without=blah bundler still calculates the deps and messes us up
	if ! use pcap; then
		sed -i -e "/^group :pcap do/,/^end$/d" Gemfile || die
	fi
	if ! use development; then
		sed -i -e "/^group :development do/,/^end$/d" Gemfile || die
	fi
	if ! use test; then
		sed -i -e "/^group :test/,/^end$/d" Gemfile || die
	fi
	if ! use test && ! use development; then
		sed -i -e "/^group :development/,/^end$/d" Gemfile || die
	fi
	if use test; then
		#We don't need simplecov
		sed -i -e "s#gem 'simplecov', '0.5.4', :require => false##" Gemfile || die
		sed -i -e "s#require 'simplecov'##" spec/spec_helper.rb || die
	fi

	#let's bogart msfupdate
	rm msfupdate
	echo "#!/bin/sh" > msfupdate
	echo "echo \"[*]\"" >> msfupdate
	echo "echo \"[*] Attempting to update the Metasploit Framework...\"" >> msfupdate
	echo "echo \"[*]\"" >> msfupdate
	echo "echo \"\"" >> msfupdate
	if [[ ${PV} == "9999" ]] ; then
		echo "if [ -x /usr/bin/smart-live-rebuild ]; then" >> msfupdate
		echo "	smart-live-rebuild -f net-analyzer/metasploit" >> msfupdate
		echo "else" >> msfupdate
		echo "	echo \"Please install app-portage/smart-live-rebuild for a better experience.\"" >> msfupdate
		echo "emerge --oneshot \"=${CATEGORY}/${PF}\"" >> msfupdate
		echo "fi" >> msfupdate
	else
		echo "echo \"Unable to update tagged version of metasploit.\"" >> msfupdate
		echo "echo \"If you want the latest please install and eselect the live version (metasploit9999)\"" >> msfupdate
		echo "echo \"emerge metasploit:9999 -vat && eselect metasploit set metasploit9999\"" >> msfupdate
	fi
	#this is set executable in src_install

	#install our database.yml file before tests are run
	cp "${FILESDIR}"/database.yml config/

}

each_ruby_prepare() {
	BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
	BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die

	#force all metasploit executables to ruby19, ruby18 is not supported anymore and ruby20 is not supported yet
	#https://dev.metasploit.com/redmine/issues/8357
	for file in $(ls -1 msf*)
	do
		#poorly adapted from python.eclass
		sed -e "1s:^#![[:space:]]*\([^[:space:]]*/usr/bin/env[[:space:]]\)\?[[:space:]]*\([^[:space:]]*/\)\?ruby\([[:digit:]]\+\(\.[[:digit:]]\+\)\?\)\?\(\$\|[[:space:]].*\):#!\1\2${RUBY}:" -i "${file}" || die "Conversion of shebang in '${file}' failed"
	done
}

each_ruby_test() {
	#review dev-python/pymongo for ways to make the test compatible with FEATURES=network-sandbox

	#we bogart msfupdate so no point in trying to test it
	rm spec/msfupdate_spec.rb || die
	#we don't really want to be uploading to virustotal during the tests
	rm spec/tools/virustotal_spec.rb || die

	# https://dev.metasploit.com/redmine/issues/8425
	BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle exec rake db:create || die
	BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle exec rake db:migrate || die

	MSF_DATABASE_CONFIG=config/database.yml BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle exec rake  || die
	su postgres -c "dropuser msf_test_user" || die "failed to cleanup msf_test-user"
}

each_ruby_install() {
	#Tests have already been run, we don't need this stuff
	rm -r spec || die
	rm -r test || die
	rm Gemfile.lock || die

	#I'm 99% sure that this will only work for as long as we only support one ruby version.  Creativity will be needed if we wish to support multiple.
	# should be as simple as copying everything into the target...
	dodir /usr/$(get_libdir)/${PN}${SLOT}
	cp -R * "${ED}"/usr/$(get_libdir)/${PN}${SLOT} || die "Copy files failed"
	rm -Rf "${ED}"/usr/$(get_libdir)/${PN}${SLOT}/documentation "${ED}"/usr/$(get_libdir)/${PN}${SLOT}/README.md
	fowners -R root:0 /

}

all_ruby_install() {
	# do not remove LICENSE, bug #238137
	dodir /usr/share/doc/${PF}
	cp -R {documentation,README.md} "${ED}"/usr/share/doc/${PF} || die
	dosym /usr/share/doc/${PF}/documentation /usr/$(get_libdir)/${PN}${SLOT}/documentation

	fperms +x /usr/$(get_libdir)/${PN}${SLOT}/msfupdate

	#tell revdep-rebuild to ignore binaries meant for the target
	dodir /etc/revdep-rebuild
	cat <<-EOF > "${ED}"/etc/revdep-rebuild/99-metasploit${SLOT}
		#These dirs contain prebuilt binaries for running on the TARGET not the HOST
		SEARCH_DIRS_MASK="/usr/lib*/${PN}${SLOT}/data/meterpreter"
		SEARCH_DIRS_MASK="/usr/lib*/${PN}${SLOT}/data/exploits"
		SEARCH_DIRS_MASK="/usr/lib*/${PN}${SLOT}/data/android/libs"
	EOF
}

pkg_postinst() {
	elog "Before use you should run 'env-update' and '. /etc/profile'"
	elog "otherwise you may be missing important environmental variables."

	elog "You need to prepare the database by running:"
	elog "emerge --config postgresql-server"
	elog "/etc/init.d/postgresql-<version> start"
	elog "emerge --config =metasploit-${PV}"

	"${EROOT}"/usr/bin/eselect metasploit set --use-old ${PN}${SLOT}

	einfo
	elog "Adjust /usr/lib/${PN}${SLOT}/config/database.yml if necessary"
}

pkg_config() {
	einfo "If the following fails, it is likely because you forgot to start/config postgresql first"
	su postgres -c "createuser msf_user -D -S -R"
	su postgres -c "createdb --owner=msf_user msf_database"
}
