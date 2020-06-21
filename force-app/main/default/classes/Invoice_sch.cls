global class Invoice_sch implements Schedulable 
{
    global void execute(System.SchedulableContext sc)
    { 
        InvoiceBatch test1Obj=new InvoiceBatch();
        
        Database.executeBatch(test1Obj);
    }
}