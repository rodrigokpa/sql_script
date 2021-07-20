select GETDATE() --2015-02-23 14:42:39.213

-- ano  YYYY - 4 digitos

select CONVERT(varchar,getdate()) --Feb 23 2015  2:42PM

select CONVERT(varchar, getdate(),100) --Feb 23 2015  2:42PM

select CONVERT(varchar, getdate(),101) --02/23/2015

select CONVERT(varchar, getdate(),102) --2015.02.23

select CONVERT(varchar, getdate(),103) --23/02/2015

select CONVERT(varchar, getdate(),104) --23.02.2015

select CONVERT(varchar, getdate(),105) --23-02-2015

select CONVERT(varchar, getdate(),106) --23 Feb 2015

select CONVERT(varchar, getdate(),107) --Feb 23, 2015

select CONVERT(varchar, getdate(),108) --14:44:30

select CONVERT(varchar, getdate(),109) --Feb 23 2015  2:44:41:037PM

select CONVERT(varchar, getdate(),110) --02-23-2015

select CONVERT(varchar, getdate(),111) --2015/02/23

select CONVERT(varchar, getdate(),112) --20150223

select CONVERT(varchar, getdate(),113) --23 Feb 2015 14:45:30:957

select CONVERT(varchar, getdate(),114) --14:45:42:883

select CONVERT(varchar, getdate(),120) --2015-02-23 14:45:54

select CONVERT(varchar, getdate(),121) --2015-02-23 14:46:04.640

select CONVERT(varchar, getdate(),126) --2015-02-23T14:46:15.160

select CONVERT(varchar, getdate(),127) --2015-02-23T14:46:25.960

select CONVERT(varchar, getdate(),130) -- 5 ????? ?????? 1436  2:46:39:

select CONVERT(varchar, getdate(),131) -- 5/05/1436  2:46:54:377PM

select CONVERT(varchar, getdate(),0) -- Feb 23 2015  2:47PM

select CONVERT(varchar, getdate(),9) --Feb 23 2015  2:47:23:797PM

select CONVERT(varchar, getdate(),13) --23 Feb 2015 14:47:38:250


select CONVERT(varchar, getdate(),20) --2015-02-23 14:47:49

select CONVERT(varchar, getdate(),21) --2015-02-23 14:47:59.370



--YY - dois digitos

select CONVERT(varchar, getdate(),1) --02/23/15

select CONVERT(varchar, getdate(),2) --15.02.23

select CONVERT(varchar, getdate(),3) --23/02/15

select CONVERT(varchar, getdate(),4) --23.02.15

select CONVERT(varchar, getdate(),5) --23.02.15

select CONVERT(varchar, getdate(),6) --23 Feb 15

select CONVERT(varchar, getdate(),7) --Feb 23, 15

select CONVERT(varchar, getdate(),8) --14:49:26


select CONVERT(varchar, getdate(),10) --02-23-15

select CONVERT(varchar, getdate(),11) --15/02/23

select CONVERT(varchar, getdate(),12) --150223

select CONVERT(varchar, getdate(),14) --14:50:15:010

----------------------------------------------------------------------


-- string em data



select cast('20150223' as DATE)

select cast('20150223' as datetime)

select cast('20150223' as time)
