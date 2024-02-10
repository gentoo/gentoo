# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN/f/F}-$(ver_rs 4 '-')
inherit autotools flag-o-matic

DESCRIPTION="Relational database offering many ANSI SQL:2003 and some SQL:2008 features"
HOMEPAGE="https://www.firebirdsql.org/"
SRC_URI="
	https://github.com/FirebirdSQL/firebird/releases/download/R$(ver_rs 1-3 '_' $(ver_cut 1-3))/${MY_P}.tar.bz2
	doc? ( ftp://ftpc.inprise.com/pub/interbase/techpubs/ib_b60_doc.zip )
"
S="${WORKDIR}/${MY_P}"

LICENSE="IDPL Interbase-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +server xinetd"

BDEPEND="
	>=dev-util/btyacc-3.0-r2
	doc? ( app-arch/unzip )
"
# FIXME: cloop?
DEPEND="
	dev-libs/icu:=
	dev-libs/libedit
	dev-libs/libtommath
"
RDEPEND="
	${DEPEND}
	acct-group/firebird
	acct-user/firebird
	xinetd? ( virtual/inetd )
	!sys-cluster/ganglia
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.2.32703.0-unbundle.patch
	"${FILESDIR}"/${PN}-3.0.2.32703.0-cloop-compiler.patch
)

pkg_pretend() {
	if [[ -e /var/run/${PN}/${PN}.pid ]] ; then
		ewarn
		ewarn "The presence of server connections may prevent isql or gsec"
		ewarn "from establishing an embedded connection. Accordingly,"
		ewarn "creating employee.fdb or security3.fdb could fail."
		ewarn "It is more secure to stop the firebird daemon before running emerge."
		ewarn
	fi
}

check_sed() {
	MSG="sed of $3, required $2 line(s) modified $1"
	einfo "${MSG}"
	[[ $1 -ge $2 ]] || die "${MSG}"
}

src_unpack() {
	unpack "${MY_P}.tar.bz2"
	if use doc; then
		# Unpack docs
		mkdir "manuals" || die
		cd "manuals" || die
		unpack ib_b60_doc.zip
	fi
}

src_prepare() {
	default

	# Rename references to isql to fbsql
	# sed vs patch for portability and addtional location changes
	check_sed "$(sed -i -e 's:"isql :"fbsql :w /dev/stdout' \
		src/isql/isql.epp | wc -l)" "1" "src/isql/isql.epp" # 1 line
	check_sed "$(sed -i -e 's:isql :fbsql :w /dev/stdout' \
		src/msgs/history2.sql | wc -l)" "4" "src/msgs/history2.sql" # 4 lines
	check_sed "$(sed -i -e 's:--- ISQL:--- FBSQL:w /dev/stdout' \
		-e 's:isql :fbsql :w /dev/stdout' \
		-e 's:ISQL :FBSQL :w /dev/stdout' \
		src/msgs/messages2.sql | wc -l)" "6" "src/msgs/messages2.sql" # 6 lines

	find . -name \*.sh -exec chmod +x {} + || die
	rm -r extern/{btyacc,editline,icu} || die

	eautoreconf
}

src_configure() {
	filter-flags -fprefetch-loop-arrays
	filter-mfpmath sse

	# otherwise this doesnt build with gcc-6
	# http://tracker.firebirdsql.org/browse/CORE-5099
	append-cflags -fno-sized-deallocation -fno-delete-null-pointer-checks
	append-cxxflags -fno-sized-deallocation -fno-delete-null-pointer-checks -std=c++11

	local myeconfargs=(
		--prefix=/usr/$(get_libdir)/firebird
		--with-editline
		--with-system-editline
		--with-fbbin=/usr/bin
		--with-fbsbin=/usr/sbin
		--with-fbconf=/etc/${PN}
		--with-fblib=/usr/$(get_libdir)
		--with-fbinclude=/usr/include
		--with-fbdoc=/usr/share/doc/${PF}
		--with-fbudf=/usr/$(get_libdir)/${PN}/UDF
		--with-fbsample=/usr/share/doc/${PF}/examples
		--with-fbsample-db=/usr/share/doc/${PF}/examples/db
		--with-fbhelp=/usr/$(get_libdir)/${PN}/help
		--with-fbintl=/usr/$(get_libdir)/${PN}/intl
		--with-fbmisc=/usr/share/${PN}
		--with-fbsecure-db=/etc/${PN}
		--with-fbmsg=/usr/$(get_libdir)/${PN}
		--with-fblog=/var/log/${PN}/
		--with-fbglock=/var/run/${PN}
		--with-fbplugins=/usr/$(get_libdir)/${PN}/plugins
		--with-gnu-ld
	)
	econf "${myeconfargs[@]}"
}

# from linux underground, merging into this here
src_install() {
	if use doc; then
		dodoc -r doc
		find "${WORKDIR}"/manuals -type f -iname "*.pdf" -exec dodoc '{}' + || die
	fi

	cd "${S}/gen/Release/${PN}" || die

	doheader include/*
	dolib.so lib/*.so*

	# links for backwards compatibility
	insinto /usr/$(get_libdir)
	dosym libfbclient.so /usr/$(get_libdir)/libgds.so
	dosym libfbclient.so /usr/$(get_libdir)/libgds.so.0
	dosym libfbclient.so /usr/$(get_libdir)/libfbclient.so.1

	insinto /usr/share/${PN}/msg
	doins *.msg

	use server || return

	einfo "Renaming isql -> fbsql"
	mv bin/isql bin/fbsql || die "failed to rename isql -> fbsql"

	dobin bin/{fb_config,fbsql,fbsvcmgr,fbtracemgr,gbak,gfix,gpre,gsec,gsplit,gstat,nbackup,qli}
	dosbin bin/{firebird,fbguard,fb_lock_print}

	insinto /usr/share/${PN}/help
	# why???
	insopts -m0660 -o firebird -g firebird
	doins help/help.fdb

	exeinto /usr/$(get_libdir)/${PN}/intl
	doexe intl/libfbintl.so
	dosym libfbintl.so /usr/$(get_libdir)/${PN}/intl/fbintl.so

	insinto /usr/$(get_libdir)/${PN}/intl
	insopts -m0644 -o root -g root
	doins intl/fbintl.conf

	# plugins
	exeinto /usr/$(get_libdir)/${PN}/plugins
	doexe plugins/*.so
	exeinto /usr/$(get_libdir)/${PN}/plugins/udr
	doexe plugins/udr/*.so

	exeinto /usr/$(get_libdir)/${PN}/UDF
	doexe UDF/*.so

	# logging (do we really need the perms?)
	diropts -m 755 -o firebird -g firebird
	dodir /var/log/${PN}
	keepdir /var/log/${PN}

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# configuration files
	insinto /etc/${PN}/plugins
	doins plugins/udr_engine.conf
	insinto /etc/${PN}
	doins {databases,fbtrace,firebird,plugins}.conf

	# install secutity3.fdb
	insopts -m0660 -o firebird -g firebird
	doins security3.fdb

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/${PN}.xinetd.3.0" ${PN}
	else
		newinitd "${FILESDIR}/${PN}.init.d.3.0" ${PN}
	fi

	if use examples; then
		cd examples || die
		insinto /usr/share/${PN}/examples
		insopts -m0644 -o root -g root
		doins -r api
		doins -r dbcrypt
		doins -r include
		doins -r interfaces
		doins -r package
		doins -r stat
		doins -r udf
		doins -r udr
		doins CMakeLists.txt
		doins functions.c
		doins README
		insinto /usr/share/${PN}/examples/empbuild
		insopts -m0660 -o firebird -g firebird
		doins empbuild/employee.fdb
	fi

	elog "Starting with version 3, server mode is set in firebird.conf"
	elog "The default setting is superserver."
	elog
	elog "If you're using UDFs, please remember to move them to /usr/$(get_libdir)/firebird/UDF"
}
