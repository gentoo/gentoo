/* Copyright (c) 2001-2009, The HSQL Development Group
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of the HSQL Development Group nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL HSQL DEVELOPMENT GROUP, HSQLDB.ORG,
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


package org.hsqldb.test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.TimeZone;

import junit.framework.TestCase;
import junit.framework.TestResult;

/**
 * Created on Apr 28, 2005
 * @author Antranig Basman (antranig@caret.cam.ac.uk)
 */
public class TestBug1191815 extends TestBase {

    public TestBug1191815(String name) {
        super(name);
    }

    public void test() throws Exception {

        try {
            Connection conn = newConnection();
            Statement  stmt = conn.createStatement();

            stmt.executeUpdate("drop table testA if exists;");
            stmt.executeUpdate("create table testA(data timestamp);");

            TimeZone pst = TimeZone.getTimeZone("PST");
            Calendar cal = new GregorianCalendar(pst);

            cal.clear();
            cal.set(2005, 0, 1, 0, 0, 0);


            // yyyy-mm-dd hh:mm:ss.fffffffff
            Timestamp ts = new Timestamp(cal.getTimeInMillis());
            ts.setNanos(1000);
            PreparedStatement ps =
                conn.prepareStatement("insert into testA values(?)");

            ps.setTimestamp(1, ts, cal);
            ps.execute();
            ps.setTimestamp(1, ts, null);
            ps.execute();

            String sql = "select * from testA";

            stmt = conn.createStatement();

            ResultSet rs = stmt.executeQuery(sql);

            rs.next();

            Timestamp returned = rs.getTimestamp(1, cal);

            rs.next();

            Timestamp def = rs.getTimestamp(1, null);

            assertEquals(ts, returned);
            assertEquals(ts, def);
        } catch (Exception e) {
            e.printStackTrace();
            fail();
        }
    }

    public static void main(String[] args) throws Exception {

        TestResult            result;
        TestCase              test;
        java.util.Enumeration exceptions;
        java.util.Enumeration failures;
        int                   count;

        result = new TestResult();
        test   = new TestBug1191815("test");

        test.run(result);

        count = result.failureCount();

        System.out.println("TestBug1192000 failure count: " + count);

        failures = result.failures();

        while (failures.hasMoreElements()) {
            System.out.println(failures.nextElement());
        }
    }
}

