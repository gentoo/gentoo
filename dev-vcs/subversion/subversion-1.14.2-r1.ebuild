# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE="none"
GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python3_{8..11} )
USE_RUBY="ruby27 ruby26"

inherit autotools bash-completion-r1 db-use depend.apache flag-o-matic java-pkg-opt-2 libtool multilib perl-module prefix python-any-r1 ruby-single xdg-utils

MY_P="${P/_/-}"
DESCRIPTION="Advanced version control system"
HOMEPAGE="https://subversion.apache.org/"
SRC_URI="mirror://apache/${PN}/${MY_P}.tar.bz2
	https://dev.gentoo.org/~polynomial-c/${PN}-1.10.0_rc1-patches-1.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD MIT BSD-2 FSFAP unicode"
SLOT="0"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
fi
IUSE="apache2 berkdb debug doc extras gnome-keyring java kwallet nls perl plaintext-password-storage ruby sasl test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/bzip2
	app-arch/lz4
	>=dev-db/sqlite-3.7.12
	>=dev-libs/apr-1.5:1
	>=dev-libs/apr-util-1.5:1
	dev-libs/expat
	dev-libs/libutf8proc:=
	>=net-libs/serf-1.3.4
	sys-apps/file
	sys-libs/zlib
	berkdb? ( >=sys-libs/db-4.0.14:= )
	gnome-keyring? (
		dev-libs/glib:2
		app-crypt/libsecret
		sys-apps/dbus
	)
	kwallet? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/ki18n:5
		kde-frameworks/kwallet:5
		sys-apps/dbus
	)
	perl? ( dev-lang/perl:= )
	ruby? ( ${RUBY_DEPS} )
	sasl? ( dev-libs/cyrus-sasl )
"
RDEPEND="${COMMON_DEPEND}
	apache2? (
		acct-group/apache
		acct-user/apache
		www-servers/apache[apache2_modules_dav]
	)
	!apache2? (
		acct-group/svnusers
		acct-user/svn
	)
	java? ( >=virtual/jre-1.8:* )
	nls? ( virtual/libintl )
	perl? ( dev-perl/URI )
"
# Note: ctypesgen doesn't need PYTHON_USEDEP, it's used once
DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:* )
"
BDEPEND="
	virtual/pkgconfig
	!!<sys-apps/sandbox-1.6
	doc? ( app-doc/doxygen )
	kwallet? ( kde-frameworks/kdelibs4support:5 )
	nls? ( sys-devel/gettext )
	perl? ( dev-lang/swig )
	ruby? ( dev-lang/swig )
	test? ( ${PYTHON_DEPS} )
"

want_apache

pkg_setup() {
	if use berkdb ; then
		local apu_bdb_version="$(${EPREFIX}/usr/bin/apu-1-config --includes \
			| grep -Eoe '-I${EPREFIX}/usr/include/db[[:digit:]]\.[[:digit:]]' \
			| sed 's:.*b::')"
		einfo
		if [[ -z "${SVN_BDB_VERSION}" ]] ; then
			if [[ -n "${apu_bdb_version}" ]] ; then
				SVN_BDB_VERSION="${apu_bdb_version}"
				einfo "Matching db version to apr-util"
			else
				SVN_BDB_VERSION="$(db_ver_to_slot "$(db_findver sys-libs/db 2>/dev/null)")"
				einfo "SVN_BDB_VERSION variable isn't set. You can set it to enforce using of specific version of Berkeley DB."
			fi
		fi
		einfo "Using: Berkeley DB ${SVN_BDB_VERSION}"
		einfo

		if [[ -n "${apu_bdb_version}" && "${SVN_BDB_VERSION}" != "${apu_bdb_version}" ]]; then
			eerror "APR-Util is linked against Berkeley DB ${apu_bdb_version}, but you are trying"
			eerror "to build Subversion with support for Berkeley DB ${SVN_BDB_VERSION}."
			eerror "Rebuild dev-libs/apr-util or set SVN_BDB_VERSION=\"${apu_bdb_version}\"."
			eerror "Aborting to avoid possible run-time crashes."
			die "Berkeley DB version mismatch"
		fi
	fi

	depend.apache_pkg_setup

	java-pkg-opt-2_pkg_setup

	# https://issues.apache.org/jira/browse/SVN-4813#comment-16813739
	append-cppflags -P

	if use debug ; then
		append-cppflags -DSVN_DEBUG -DAP_DEBUG
	fi

	# http://mail-archives.apache.org/mod_mbox/subversion-dev/201306.mbox/%3C51C42014.3060700@wandisco.com%3E
	[[ ${CHOST} == *-solaris2* ]] && append-cppflags -D__EXTENSIONS__

	# Allow for custom repository locations.
	SVN_REPOS_LOC="${SVN_REPOS_LOC:-${EPREFIX}/var/svn}"

	if use ruby ; then
		local rbslot
		RB_VER=""
		for rbslot in $(sed 's@\([[:digit:]]\+\)\([[:digit:]]\)@\1.\2@g' <<< ${USE_RUBY//ruby}) ; do
			if has_version dev-lang/ruby:${rbslot} ;  then
				RB_VER="${rbslot/.}"
				break
			fi
		done
		[[ -z "${RB_VER}" ]] && die "No useable ruby version found"
	fi
}

src_prepare() {
	# https://bugs.gentoo.org/721300
	rm "${WORKDIR}"/patches/subversion-1.10.0_rc1-utf8proc_include.patch || die

	eapply "${WORKDIR}/patches"

	eapply "${FILESDIR}"/subversion-1.14.2-python3.11.patch
	eapply_user

	chmod +x build/transform_libtool_scripts.sh || die

	sed -i \
		-e "s/\(BUILD_RULES=.*\) bdb-test\(.*\)/\1\2/g" \
		-e "s/\(BUILD_RULES=.*\) test\(.*\)/\1\2/g" configure.ac

	# this bites us in particular on Solaris
	sed -i -e '1c\#!/usr/bin/env sh' build/transform_libtool_scripts.sh || \
		die "/bin/sh is not POSIX shell!"

	hprefixify build/ac-macros/svn-macros.m4

	eautoconf
	elibtoolize

	sed -e 's/\(libsvn_swig_py\)-\(1\.la\)/\1-$(EPYTHON)-\2/g' \
		-i build-outputs.mk || die "sed failed"

	xdg_environment_reset
}

src_configure() {
	local myconf=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		$(use_with apache2 apache-libexecdir)
		$(use_with apache2 apxs "${EPREFIX}"/usr/bin/apxs)
		$(use_with berkdb berkeley-db "db.h:${EPREFIX}/usr/include/db${SVN_BDB_VERSION}::db-${SVN_BDB_VERSION}")
		--without-ctypesgen
		--disable-runtime-module-search
		$(use_with gnome-keyring)
		$(use_enable java javahl)
		$(use_with java jdk "${JAVA_HOME}")
		$(use_with kwallet)
		$(use_enable nls)
		$(use_enable plaintext-password-storage)
		$(use_with sasl)
		--with-serf
		--with-apr="${EPREFIX}/usr/bin/apr-1-config"
		--with-apr-util="${EPREFIX}/usr/bin/apu-1-config"
		--disable-experimental-libtool
		--without-jikes
		--disable-mod-activation
		--disable-static
		--enable-svnxx
	)

	if use perl || use ruby; then
		myconf+=( --with-swig )
	else
		myconf+=( --without-swig )
	fi

	if use java ; then
		myconf+=( --without-junit )
	fi

	case ${CHOST} in
		*-solaris*)
			# need -lintl to link
			use nls && append-libs intl
			# this breaks installation, on x64 echo replacement is 32-bits
			myconf+=( --disable-local-library-preloading )
		;;
		*)
			# inject LD_PRELOAD entries for easy in-tree development
			myconf+=( --enable-local-library-preloading )
		;;
	esac

	#version 1.7.7 again tries to link against the older installed version and fails, when trying to
	#compile for x86 on amd64, so workaround this issue again
	#check newer versions, if this is still/again needed
	#myconf+=( --disable-disallowing-of-undefined-references )

	# for build-time scripts
	if use test; then
		python_setup
	fi

	# Remove when >=dev-libs/libutf8proc-2.5.0 is stable
	# https://bugs.gentoo.org/721300
	append-cppflags -I"${EPREFIX}"/usr/include/libutf8proc

	# allow overriding Python include directory
	ac_cv_path_RUBY=$(usex ruby "${EPREFIX}/usr/bin/ruby${RB_VER}" "none") \
	ac_cv_path_RDOC=$(usex ruby "${EPREFIX}/usr/bin/rdoc${RB_VER}" "none") \
	econf "${myconf[@]}"
}

src_compile() {
	emake local-all

	if use perl ; then
		emake swig-pl
	fi

	if use ruby ; then
		emake swig-rb
	fi

	if use java ; then
		emake -j1 JAVAC_FLAGS="$(java-pkg_javac-args) -encoding iso8859-1" javahl
	fi

	if use extras ; then
		emake tools
	fi

	if use doc ; then
		doxygen doc/doxygen.conf || die "Building of Subversion HTML documentation failed"

		if use java; then
			emake doc-javahl
		fi
	fi
}

src_test() {
	#if has_version ~${CATEGORY}/${P} ; then
		default
	#else
	#	ewarn "The test suite shows errors when there is an older version of"
	#	ewarn "${CATEGORY}/${PN} installed. Please install =${CATEGORY}/${P}*"
	#	ewarn "before running the test suite."
	#	ewarn "Test suite skipped."
	#fi
}

src_install() {
	emake -j1 DESTDIR="${D}" local-install

	if use perl ; then
		emake DESTDIR="${D}" INSTALLDIRS="vendor" install-swig-pl
		perl_delete_localpod
		find "${ED}" \( -name .packlist -o -name "*.bs" \) -delete || die
	fi

	if use ruby ; then
		emake DESTDIR="${D}" install-swig-rb
	fi

	if use java ; then
		emake DESTDIR="${D}" install-javahl
		java-pkg_regso "${ED}"/usr/$(get_libdir)/libsvnjavahl*$(get_libname)
		java-pkg_dojar "${ED}"/usr/$(get_libdir)/svn-javahl/svn-javahl.jar
		rm -fr "${ED}"/usr/$(get_libdir)/svn-javahl/*.jar
	fi

	# Install Apache module configuration.
	if use apache2 ; then
		keepdir "${APACHE_MODULES_CONFDIR}"
		insinto "${APACHE_MODULES_CONFDIR}"
		doins "${FILESDIR}/47_mod_dav_svn.conf"
	fi

	# Install Bash Completion, bug 43179.
	newbashcomp tools/client-side/bash_completion svn
	bashcomp_alias svn svn{admin,dumpfilter,look,sync,version}
	rm -f tools/client-side/bash_completion

	# Install hot backup script, bug 54304.
	newbin tools/backup/hot-backup.py svn-hot-backup
	rm -fr tools/backup

	# Install svnserve init-script and xinet.d snippet, bug 43245.
	newinitd "${FILESDIR}"/svnserve.initd3 svnserve
	newconfd "${FILESDIR}"/svnserve.confd svnserve
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/svnserve.xinetd svnserve

	#adjust default user and group with disabled apache2 USE flag, bug 381385
	if ! use apache2 ; then
		sed -e "s\USER:-apache\USER:-svn\g" \
			-e "s\GROUP:-apache\GROUP:-svnusers\g" \
			-i "${ED}"/etc/init.d/svnserve || die
		sed -e "0,/apache/s//svn/" \
			-e "s:apache:svnusers:" \
			-i "${ED}"/etc/xinetd.d/svnserve || die
	fi

	# Install documentation.
	dodoc CHANGES COMMITTERS README
	dodoc tools/xslt/svnindex.{css,xsl}
	rm -fr tools/xslt

	# Install extra files.
	if use extras ; then
		cat <<- EOF > 80subversion-extras
			PATH="${EPREFIX}/usr/$(get_libdir)/subversion/bin"
			ROOTPATH="${EPREFIX}/usr/$(get_libdir)/subversion/bin"
		EOF
		doenvd 80subversion-extras

		emake DESTDIR="${D}" toolsdir="/usr/$(get_libdir)/subversion/bin" install-tools

		find tools \( -name "*.bat" -o -name "*.in" -o -name ".libs" \) -print0 | xargs -0 rm -fr
		rm -fr tools/client-side/svnmucc
		rm -fr tools/server-side/{svn-populate-node-origins-index,svnauthz-validate}*
		rm -fr tools/{buildbot,dev,diff,po}
	fi

	if use doc ; then
		docinto html
		dodoc -r doc/doxygen/html/*

		if use java ; then
			java-pkg_dojavadoc doc/javadoc
		fi
	fi

	find "${D}" -name '*.la' -type f -delete || die

	cd "${ED}"/usr/share/locale
	for i in * ; do
		if [[ ${i} != *${LINGUAS}* ]] ; then
			rm -r ${i} || die
		fi
	done
}

pkg_preinst() {
	# Compare versions of Berkeley DB, bug 122877.
	if use berkdb && [[ -f "${EROOT}/usr/bin/svn" ]] ; then
		OLD_BDB_VERSION="$(scanelf -nq "${EROOT}/usr/$(get_libdir)/libsvn_subr-1$(get_libname 0)" | grep -Eo "libdb-[[:digit:]]+\.[[:digit:]]+" | sed -e "s/libdb-\(.*\)/\1/")"
		NEW_BDB_VERSION="$(scanelf -nq "${ED}/usr/$(get_libdir)/libsvn_subr-1$(get_libname 0)" | grep -Eo "libdb-[[:digit:]]+\.[[:digit:]]+" | sed -e "s/libdb-\(.*\)/\1/")"
		if [[ "${OLD_BDB_VERSION}" != "${NEW_BDB_VERSION}" ]] ; then
			CHANGED_BDB_VERSION="1"
		fi
	fi
}

pkg_postinst() {
	if [[ -n "${CHANGED_BDB_VERSION}" ]] ; then
		ewarn "You upgraded from an older version of Berkeley DB and may experience"
		ewarn "problems with your repository. Run the following commands as root to fix it:"
		ewarn "    db4_recover -h ${SVN_REPOS_LOC}/repos"
		ewarn "    chown -Rf apache:apache ${SVN_REPOS_LOC}/repos"
	fi

	ewarn "If you run subversion as a daemon, you will need to restart it to avoid module mismatches."
}

pkg_postrm() {
	:
}

pkg_config() {
	# Remember: Don't use ${EROOT}${SVN_REPOS_LOC} since ${SVN_REPOS_LOC}
	# already has EPREFIX in it
	einfo "Initializing the database in ${SVN_REPOS_LOC}..."
	if [[ -e "${SVN_REPOS_LOC}/repos" ]] ; then
		echo "A Subversion repository already exists and I will not overwrite it."
		echo "Delete \"${SVN_REPOS_LOC}/repos\" first if you're sure you want to have a clean version."
	else
		mkdir -p "${SVN_REPOS_LOC}/conf"

		einfo "Populating repository directory..."
		# Create initial repository.
		"${EROOT}/usr/bin/svnadmin" create "${SVN_REPOS_LOC}/repos"

		einfo "Setting repository permissions..."
		SVNSERVE_USER="$(. "${EROOT}/etc/conf.d/svnserve"; echo "${SVNSERVE_USER}")"
		SVNSERVE_GROUP="$(. "${EROOT}/etc/conf.d/svnserve"; echo "${SVNSERVE_GROUP}")"
		if use apache2 ; then
			[[ -z "${SVNSERVE_USER}" ]] && SVNSERVE_USER="apache"
			[[ -z "${SVNSERVE_GROUP}" ]] && SVNSERVE_GROUP="apache"
		else
			[[ -z "${SVNSERVE_USER}" ]] && SVNSERVE_USER="svn"
			[[ -z "${SVNSERVE_GROUP}" ]] && SVNSERVE_GROUP="svnusers"
		fi
		chmod -Rf go-rwx "${SVN_REPOS_LOC}/conf"
		chmod -Rf o-rwx "${SVN_REPOS_LOC}/repos"
		chown -Rf ${SVNSERVE_USER}:${SVNSERVE_GROUP} "${SVN_REPOS_LOC}/repos"
	fi
}
